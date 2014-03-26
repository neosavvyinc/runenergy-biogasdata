require 'net/ftp'

class FtpDetail < ActiveRecord::Base
  attr_accessible :asset_id, :password, :url, :username, :ftp_column_monitor_points_attributes, :minimum_date, :folder_path, :date_column_name, :pause, :last_date_collected
  belongs_to :asset
  has_many :ftp_column_monitor_points
  has_many :ftp_import_logs

  accepts_nested_attributes_for :ftp_column_monitor_points, :allow_destroy => true

  def self.file_name_as_date(file)
    Date.strptime(file.gsub(/[^0-9]/, ''), '%y%m%d')
  end

  def self.list_csv_files(ftp_list)
    if ftp_list
      ftp_list.select {
          |file|
        file.split(' ').last.match(/.CSV|.csv/)
      }.map { |file|
        file_name = file.split(' ').last
        {:file => file_name, :date => file_name_as_date(file_name)}
      }.sort_by { |e| e[:date] }
    else
      raise 'You must pass in a valid ftp_list object in order to get a list of files'
    end
  end

  before_create :defaults

  def defaults
    self.folder_path ||='/DATA'
  end

  def import
    unless self.pause
      begin
        Net::FTP.open(self.url, self.username, self.password) do |ftp|
          #Change to correct directory on server
          ftp.chdir(self.folder_path || '/DATA')

          #List files in the new directory
          files = self.last_date_collected.nil? ? FtpDetail.list_files(ftp.list) : FtpDetail.list_files(ftp.list).select { |f| f[:date] >= last_date_collected }

          unless files.empty?

          end
        end
      rescue Exception => e
        puts FtpImportLog.create(:ftp_detail => self, :error => e).error
      end
    end
  end

  protected
  def import_file(ftp, file)
    unless file.blank?
      ftp.getbinaryfile(file[:file], 'tmp/current_import.csv')
    else
      raise 'You must pass a valid file for import.'
    end
  end


end
