namespace :helpers do
  namespace :asset do
    task :delete_empty_locations => :environment do
      Asset.all.each do |a|
        if Location.where(:id => a.location_id).first.nil?
          a.delete
          puts "DELETED #{a.unique_identifier}"
        end
      end
    end
    task :delete_empty_monitor_classes => :environment do
      Asset.all.each do |a|
        if MonitorClass.where(:id => a.monitor_class_id).first.nil?
          a.delete
          puts "DELETED #{a.unique_identifier}"
        end
      end
    end
  end
end