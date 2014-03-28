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
    task :assign_random_heat_map_coordinates => :environment do
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
    task :import_heat_map_coordinates, [:file_path] => [:environment] do |t, args|
      puts "Import data frome #{args[:file_path]}"

      #Fixed Rows
      UNIQUE_IDENTIFIER_IDX = 0
      LOCATION_IDX = 2
      SECTION_IDX = 3
      MONITOR_CLASS_IDX = 4
      X_IDX = 5
      Y_IDX = 6

      #Asset Properties
      PUMP_VOLUME = {:idx => 8, :name => 'Pump Volume'}
      WELL_DEPTH = {:idx => 9, :name => 'Well depth (mBTOC)'}
      PUMP_INSTALL_DEPTH = {:idx => 10, :name => 'Pump Install Depth (mBTOC)'}

      properties = [PUMP_VOLUME, WELL_DEPTH, PUMP_INSTALL_DEPTH]

      idx = 0
      CSV.foreach(args[:file_path]) do |row|
        if idx > 1
          location = Location.where(:site_name => row[LOCATION_IDX]).first || Location.create(:site_name => row[LOCATION_IDX])
          monitor_class = MonitorClass.where(:name => row[MONITOR_CLASS_IDX]).first || MonitorClass.create(:name => row[MONITOR_CLASS_IDX])

          LocationsMonitorClass.lazy_load(location.id, monitor_class.id)

          unless location.nil? or monitor_class.nil?
            puts "Found location: #{row[LOCATION_IDX]}, monitor class: #{row[MONITOR_CLASS_IDX]}"
            asset = Asset.where(:location_id => location.id, :monitor_class_id => monitor_class.id, :unique_identifier => row[UNIQUE_IDENTIFIER_IDX]).first || Asset.create(:location_id => location.id, :monitor_class_id => monitor_class.id, :unique_identifier => row[UNIQUE_IDENTIFIER_IDX])
            unless asset.nil?
              puts "Found asset: #{row[UNIQUE_IDENTIFIER_IDX]}"

              #Create section
              section = Section.lazy_load(:name => row[SECTION_IDX], :location_id => location.id)

              #Assign section to asset
              asset.section = section
              asset.heat_map_detail ||= HeatMapDetail.new
              asset.heat_map_detail.x = row[X_IDX]
              asset.heat_map_detail.y = row[Y_IDX]

              #Create properties for class if necessary
              properties.each do |aph|
                unless row[aph[:idx]].blank?
                  asset_property = AssetProperty.where(:name => aph[:name], :monitor_class_id => monitor_class.id).first || AssetProperty.create(:name => aph[:name], :monitor_class_id => monitor_class.id)
                  asset.asset_property_values << AssetPropertyValue.create(:asset_property_id => asset_property.id, :value => row[aph[:idx]])
                end
              end

              asset.save
              puts "Saved asset #{asset.unique_identifier}"
            end
          end
        else
          puts "Header row #{idx}"
        end

        idx += 1
      end
    end
  end
end