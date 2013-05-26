require 'net/ftp'

namespace :data_retrieval do

  task :flares => :environment do
    flare_specifications = FlareSpecification.where(:flare_id => "LFG-FLR6")
    flare_specifications.each do |fs|
      Net::FTP.open(fs.ftp_address, fs.username, fs.password) do |ftp|
        ftp.chdir('/DATA')
        if fs.next_csv
          #Case where the monitor data has already been collected
        else
          files = ftp.list.select {
              |file|
            file.split(" ").last.match(/.CSV|.csv/)
          }.map { |file|
            file_name = file.split(" ").last
            {:file => file_name, :date => Date.strptime(file_name.gsub(/[^0-9]/, ""), "%y%m%d")}
          }.sort_by { |e| e[:date] }
          files.each do |f|
            puts f[:file]
            puts f[:date].to_s
          end
        end
      end
    end
  end

end