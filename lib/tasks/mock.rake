namespace :mock do

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