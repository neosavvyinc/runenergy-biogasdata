namespace :daily do
  namespace :ftp_detail  do
    task :import => :environment do
      FtpDetail.all.each do |fd|
        fd.import
      end
    end
  end
end