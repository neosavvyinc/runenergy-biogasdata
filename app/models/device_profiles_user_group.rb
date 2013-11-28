class DeviceProfilesUserGroup < ActiveRecord::Base
  attr_accessible :device_profile_id, :user_group_id
  belongs_to :device_profile
  belongs_to :user_group
end
