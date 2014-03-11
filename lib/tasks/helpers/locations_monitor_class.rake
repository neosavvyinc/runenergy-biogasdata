namespace :helpers do
  namespace :locations_monitor_class do
    task :delete_empty_locations => :environment do
      LocationsMonitorClass.all.each do |lmc|
        if Location.where(:id => lmc.location_id).first.nil?
          lmc.delete
          puts "DELETED #{lmc.display_name}"
        end
      end
    end
    task :delete_empty_monitor_classes => :environment do
      LocationsMonitorClass.all.each do |lmc|
        if MonitorClass.where(:id => lmc.monitor_class_id).first.nil?
          lmc.delete
          puts "DELETED #{lmc.display_name}"
        end
      end
    end
  end
end