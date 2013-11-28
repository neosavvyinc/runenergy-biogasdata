class DeviceProfilesUser < ActiveRecord::Base
  attr_accessible :device_profile_id, :user_id
  belongs_to :device_profile
  belongs_to :user
end
