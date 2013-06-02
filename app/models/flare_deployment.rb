class FlareDeployment < ActiveRecord::Base
  attr_accessible :client_flare_unique_identifier, :customer_id, :flare_data_mapping_id, :flare_specification_id, :location_id, :first_reading, :last_reading, :flare_deployment_status_code_id
  belongs_to :flare_specification
  belongs_to :location
  belongs_to :customer, :class_name => 'User', :foreign_key => 'customer_id'
  belongs_to :flare_deployment_status_code

  before_save :apply_deployment_status

  def current?
    flare_deployment_status_code == FlareDeploymentStatusCode.CURRENT
  end

  def apply_deployment_status
    if last_reading.blank?
      flare_deployment_status_code = FlareDeploymentStatusCode.CURRENT
    else
      flare_deployment_status_code = FlareDeploymentStatusCode.PAST
    end
  end
end
