class LocationsUserGroup < ActiveRecord::Base
  attr_accessible :location_id, :user_group_id
  belongs_to :location
  belongs_to :user_group
end
