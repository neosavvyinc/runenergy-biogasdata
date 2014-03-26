require 'net/ftp'

class FtpDetail < ActiveRecord::Base
  attr_accessible :asset_id, :password, :url, :username, :ftp_column_monitor_points_attributes, :minimum_date, :folder_path, :date_column_name, :time_column_name, :pause, :last_date_collected
  belongs_to :asset
  has_many :ftp_column_monitor_points
  has_many :ftp_import_logs

  accepts_nested_attributes_for :ftp_column_monitor_points, :allow_destroy => true

  def self.file_name_as_date(file)
    Date.strptime(file.gsub(/[^0-9]/, ''), '%y%m%d')
  end

  def self.list_csv_files(ftp_list)
    if ftp_list
      ftp_list.select { |file| file.split(' ').last.match(/.CSV|.csv/) }.map { |file|
        file_name = file.split(' ').last
        {:file => file_name, :date => file_name_as_date(file_name)}
      }.sort_by { |e| e[:date] }
    else
      raise 'You must pass in a valid ftp_list object in order to get a list of files'
    end
  end

  after_initialize :defaults

  def defaults
    self.folder_path ||='/DATA'
    self.date_column_name ||= 'Date'
    self.time_column_name ||= 'Time'
  end

  def display_name
    asset.try(:display_name) || "No Asset Listed #{self.id}"
  end

  def import
    if self.url and self.username and self.password and not self.pause
      begin
        Net::FTP.open(self.url, self.username, self.password) do |ftp|
          #Change to correct directory on server
          ftp.chdir(self.folder_path || '/DATA')

          #List files in the new directory
          files = (self.last_date_collected.nil? ? FtpDetail.list_csv_files(ftp.list) : FtpDetail.list_csv_files(ftp.list).select { |f| f[:date] >= self.last_date_collected })

          #Loop through files and import
          files.select { |f| f[:date] >= self.minimum_date }.each do |f|
            import_file(ftp, f)
          end
        end
      rescue Exception => e
        puts FtpImportLog.create(:ftp_detail_id => self.id, :error => e).error
      end
    end
  end

  protected
  def import_file(ftp, file)
    unless file.blank?
      #Create the temporary file for storage
      ftp.getbinaryfile(file[:file], 'tmp/current_import.csv')

      header = nil
      CSV.foreach('tmp/current_import.csv') do |row|
        if header.nil?
          #Maps header to monitor points for first row
          header = header_monitor_points(row)
        else
          #Content rows
          r = Reading.new(
              :asset_id => self.asset_id,
              :monitor_class_id => self.asset.try(:monitor_class_id),
              :location_id => self.asset.try(:location_id)
          )
          data = {}

          #Iterate throw row for data elements
          row.each_with_index do |c, idx|
            if not header[idx].nil?
              if header[idx] === self.date_column_name
                #Date Column Case
                r.taken_at = create_or_change_date(r.taken_at, c)
              elsif header[idx] === self.time_column_name
                #Time Column Case, the files date is the alternate date for init
                r.taken_at = create_or_change_time(r.taken_at, c, file[:date])
              else
                #Monitor Point Case
                data[header[idx]] = c
              end
            end
          end
          #Apply data to the reading
          r.data = data.to_json

          #Save data, if not collisions
          if DataCollision.collisions(r).size == 0
            if r.save
              puts "#{r.taken_at} for #{r.asset.try(:display_name)} created"
            end
          else
            puts "#{r.taken_at} for #{r.asset.try(:display_name)} not created because of collision"
          end
        end
      end
    else
      raise 'You must pass a valid file for import.'
    end
  end

  def header_monitor_points(header)
    if header and header.size > 0
      group = ftp_column_monitor_points.group_by { |fcmp| fcmp.column_name }
      header.map { |c|
        if c == self.date_column_name or c == self.time_column_name
          c
        else
          group[c].try(:first).try(:monitor_point).try(:name)
        end
      }
    else
      []
    end
  end

  def create_or_change_date(date, str)
    d = DateTime.strptime(str.gsub(/\//, '-').split('-').map { |dp| (dp.to_s.length == 1 ? '0' + dp.to_s : dp) }.join('-'), '%d-%m-%y')
    if date.nil?
      d
    else
      date.change(year: d.year, month: d.month, day: d.day)
    end
  end

  def create_or_change_time(time, str, alt = nil)
    t = Time.strptime(str.split(':').map { |tp| (tp.to_s.length == 1 ? '0' + tp.to_s : tp) }.join(':'), '%H:%M:%S')
    if time.nil?
      time = alt || DateTime.now
    end
    time.change(hour: t.hour, min: t.min, sec: t.sec)
  end


end
