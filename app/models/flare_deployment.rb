class FlareDeployment < ActiveRecord::Base
  attr_accessible :client_flare_unique_identifier, :customer_id, :flare_data_mapping_id, :flare_specification_id, :location_id
  belongs_to :flare_specification
  belongs_to :location
  belongs_to :customer, :class_name => 'User', :foreign_key => 'customer_id'
  has_one :flare_deployment_status

  def current?
    flare_deployment_status.blank?
  end
end
