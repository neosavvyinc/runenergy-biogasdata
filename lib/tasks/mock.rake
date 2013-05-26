namespace :mock do
  task :users => :environment do
    User.find_or_create_by_name(:name => "Dr. Rockso", :email => "doctorrockso@gmail.com", :password => "rocksorockso", :user_type_id => UserType.find_by_name("CUSTOMER").id)
    User.find_or_create_by_name(:name => "Lemmy Kilmister", :email => "lemmy@gmail.com", :password => "lemmylemmy", :user_type_id => UserType.find_by_name("OVERSEER").id)
  end

  task :countries => :environment do
    Country.find_or_create_by_name(:name => "Australia")
    puts "Countries created"
  end

  task :states => :environment do
    State.find_or_create_by_name(:name => "VIC", :country_id => Country.find_by_name("Australia").id)
    State.find_or_create_by_name(:name => "NSW", :country_id => Country.find_by_name("Australia").id)
    puts "States created"
  end

  task :locations => [:environment, :countries, :states] do
    Location.find_or_create_by_site_name(:site_name => "Elizabeth Drive Landfill", :state_id => State.find_by_name("NSW").id, :lattitude => "33o15'52.33S", :longitude => "150o45'39.26E")
    Location.find_or_create_by_site_name(:site_name => "Stevensons Road Closed Landfill", :state_id => State.find_by_name("VIC").id, :lattitude => "33o15'35.33S", :longitude => "190o45'14.26E")
    puts "Locations created"
  end

  task :companies => :environment do
    Company.find_or_create_by_name(:name => "Gasco")
    Company.find_or_create_by_name(:name => "ABM Combustible")
    Company.find_or_create_by_name(:name => "Run Energy")
    puts "Companies created"
  end

  task :flare_specifications => [:environment, :companies] do
    FlareSpecification.find_or_create_by_flare_id({
                                  :capacity_scmh => 500,
                                  :data_location => "/DATA",
                                  :flare_id => "LFG-FLR1",
                                  :ftp_address => "runflare6.dyndns.org",
                                  :manufacturer_id => Company.find_by_name("Gasco").id,
                                  :manufacturer_product_id => "P2513-01",
                                  :owner_id => Company.find_by_name("Run Energy").id,
                                  :password => "run007",
                                  :purchase_date => Date.new,
                                  :username => "runflare6",
                                  :web_address => "runflare6.dyndns.org"
                              })
    FlareSpecification.find_or_create_by_flare_id({
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
    FlareSpecification.find_or_create_by_flare_id({
                                  :capacity_scmh => 500,
                                  :data_location => "/DATA",
                                  :flare_id => "LFG-FLR6",
                                  :ftp_address => "runflare6.dyndns.org",
                                  :manufacturer_id => Company.find_by_name("ABM Combustible").id,
                                  :manufacturer_product_id => "P2513-01",
                                  :owner_id => Company.find_by_name("Run Energy").id,
                                  :password => "run007",
                                  :purchase_date => Date.new,
                                  :username => "runflare6",
                                  :web_address => "runflare6.dyndns.org"
                              })
    puts "Flare specifications created"
  end

  task :flare_deployments => [:environment, :flare_specifications, :users] do
    FlareDeployment.find_or_create_by_client_flare_id(:flare_specification_id => FlareSpecification.first.id, :location_id => Location.first.id, :client_flare_id => "LFG-FLR1-1-1", :customer_id => User.find_by_email("doctorrockso@gmail.com").id)
    FlareDeployment.find_or_create_by_client_flare_id(:flare_specification_id => FlareSpecification.last.id, :location_id => Location.last.id, :client_flare_id => "LFG-FLR1-1-10")
    puts "Flare deployments created"
  end

end