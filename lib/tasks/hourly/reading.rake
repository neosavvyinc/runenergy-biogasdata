namespace :hourly do
  namespace :reading do
    task :remedy_missing_keys => :environment do
      Location.all.each do |l|
        l.monitor_classes.each do |mc|
          cache = {}
          readings = Reading.where(:location_id => l.id, :monitor_class_id => mc.id)

          #Build out cache
          readings.each do |r|
            cache = cache.merge(JSON.parse(r.data))
          end

          #Clear out cache keys
          cache.each_key {|k| cache[k] = ''}

          #Update to include the blank values
          readings.each do |r|
            puts r.data
            r.update_attribute(:data, cache.merge(JSON.parse(r.data)))
          end
        end
      end
    end
  end
end