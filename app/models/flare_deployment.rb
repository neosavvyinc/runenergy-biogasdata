class FlareDeployment < ActiveRecord::Base
  attr_accessible :client_flare_id, :customer_id, :flare_data_mapping_id, :flare_id, :location_id
end
