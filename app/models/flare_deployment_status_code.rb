class FlareDeploymentStatusCode < ActiveRecord::Base
  attr_accessible :name

  def self.CURRENT
    find_by_name("CURRENT")
  end

  def self.PAST
    find_by_name("PAST")
  end
end
