namespace :helpers do
  namespace :ignored_column_or_conversion do
    task :process => :environment do
      MonitorClass.all.each do |mc|
        puts "<<<<<<<<< #{mc.name} >>>>>>>>>"
        mc.readings.each do |r|
          r.data = IgnoredColumnOrConversion.process(JSON.parse(r.data), mc.id)
          r.save
          puts JSON.dump(r.data)
        end
        puts "<<<<<<<<< #{mc.name} >>>>>>>>>"
      end
    end
  end
end