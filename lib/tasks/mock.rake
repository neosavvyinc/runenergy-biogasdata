namespace :mock do
  task :countries => :environment do
    Country.delete_all
    Country.create(:name => "Australia")
    puts "Countries created"
  end

  task :states => :environment do
    State.delete_all
    State.create(:name => "VIC", :country_id => Country.find_by_name("Australia").id)
    State.create(:name => "NSW", :country_id => Country.find_by_name("Australia").id)
    puts "States created"
  end

  task :locations => [:environment, :countries, :states] do
    Location.delete_all
    Location.create(:site_name => "Elizabeth Drive Landfill", :state_id => State.find_by_name("NSW").id, :lattitude => "33o15'52.33S", :longitude => "150o45'39.26E")
    Location.create(:site_name => "Stevensons Road Closed Landfill", :state_id => State.find_by_name("VIC").id, :lattitude => "33o15'35.33S", :longitude => "190o45'14.26E")
    puts "Locations created"
  end

  task :companies => :environment do
    Company.delete_all
    Company.create(:name => "Gasco")
    Company.create(:name => "ABM Combustible")
    Company.create(:name => "Run Energy")
    puts "Companies created"
  end

  task :flare_specifications => [:environment, :companies] do
    FlareSpecification.delete_all
    FlareSpecification.create({
                                  :capacity_scmh => 500,
                                  :data_location => "/DATA",
                                  :flare_id => "LFG-FLR1",
                                  :ftp_address => "runflare1.dyndns.org",
                                  :manufacturer_id => Company.find_by_name("Gasco").id,
                                  :manufacturer_product_id => "P2513-01",
                                  :owner_id => Company.find_by_name("Run Energy").id,
                                  :password => "run007",
                                  :purchase_date => Date.new,
                                  :username => "runflare1",
                                  :web_address => "runflare1.dyndns.org"
                              })
    FlareSpecification.create({
                                  :capacity_scmh => 500,
                                  :data_location => "/DATA",
                                  :flare_id => "LFG-FLR10",
                                  :ftp_address => "runflare10.dyndns.org",
                                  :manufacturer_id => Company.find_by_name("ABM Combustible").id,
                                  :manufacturer_product_id => "P2513-01",
                                  :owner_id => Company.find_by_name("Run Energy").id,
                                  :password => "run007",
                                  :purchase_date => Date.new,
                                  :username => "runflare10",
                                  :web_address => "runflare10.dyndns.org"
                              })
    puts "Flare specifications created"
  end

end