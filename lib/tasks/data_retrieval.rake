require 'net/ftp'

namespace :data_retrieval do

  task :flares => :environment do
    #Helpers
    def file_as_date(file)
      Date.strptime(file.gsub(/[^0-9]/, ""), "%y%m%d")
    end

    def list_files(ftp_list)
      if ftp_list
        ftp_list.select {
            |file|
          file.split(" ").last.match(/.CSV|.csv/)
        }.map { |file|
          file_name = file.split(" ").last
          {:file => file_name, :date => file_as_date(file_name)}
        }.sort_by { |e| e[:date] }
      else
        raise "You must pass in a valid ftp_list object in order to get a list of files"
      end
    end

    def import_file(ftp, file, flare_specification)
      unless file.blank?
        puts "Collecting #{file[:file]} for readings on #{file[:date].to_s}"
        ftp.getbinaryfile(file[:file], 'tmp/current_import.csv')
        FlareMonitorData.import('tmp/current_import.csv', flare_specification)
        flare_specification.update_statistic(file[:file], file[:date])
        puts "Completed collection #{file[:file]} for readings on #{file[:date].to_s}"
      else
        raise "You must pass in a valid file for import"
      end
    end

    #Task
    flare_specifications = FlareDeployment.all.map { |fd| fd.flare_specification }
    flare_specifications.each do |fs|
      unless fs.nil? or fs.paused?
        begin
          Net::FTP.open(fs.ftp_address, fs.username, fs.password) do |ftp|
            ftp.chdir(fs.data_location || '/DATA')
            files = list_files(ftp.list)
            unless fs.next_date.nil?
              next_date = fs.next_date
              files = files.select { |f| f[:date] >= next_date }
            end
            unless files.empty?
              files.each do |f|
                import_file(ftp, f, fs)
              end
            else
              puts "No new results found for import on #{fs.flare_unique_identifier}"
            end
          end
        rescue
          FlareImportLog.create(:message => $!, :likely_cause => "The FTP server is unavailable, wrong address, or down.", :flare_specification_id => fs.id)
          puts "#{fs.flare_unique_identifier} failed on retrieval with message #{$!}"
        end
      else
        FlareImportLog.create(:message => "There is a flare deployment without a specifications.", :likely_cause => "There should not be any deployments without specifications.", :flare_specification_id => fs.try(:id))
      end
    end
  end

end