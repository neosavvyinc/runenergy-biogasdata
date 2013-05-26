class FlareDeploymentStatus < ActiveRecord::Base
  attr_accessible :first_reading, :flare_deployment_id, :last_reading, :status
  belongs_to :flare_deployment

end
