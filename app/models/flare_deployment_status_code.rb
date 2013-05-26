class FlareDeploymentStatusCode < ActiveRecord::Base
  attr_accessible :name

  def self.CURRENT
    FlareDeploymentStatus.find_by_name("CURRENT")
  end

  def self.PAST
    FlareDeploymentStatus.find_by_name("PAST")
  end
end
