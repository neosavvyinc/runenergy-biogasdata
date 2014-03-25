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
    task :assign_heat_map_coordinates => :environment do
      Asset.all.each do |a|
        if a.heat_map_detail.nil?
          a.update_attribute(:heat_map_detail, HeatMapDetail.create)
        end
        if a.heat_map_detail.x.nil?
          a.heat_map_detail.update_attribute(:x, rand(2000))
        end
        if a.heat_map_detail.y.nil?
          a.heat_map_detail.update_attribute(:y, rand(2000))
        end
        puts "ASSET #{a.unique_identifier} - X: #{a.heat_map_detail.x}, Y: #{a.heat_map_detail.y}"
      end
    end
  end
end