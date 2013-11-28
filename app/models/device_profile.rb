class DeviceProfile < ActiveRecord::Base
  attr_accessible :name, :uid
  has_many :device_profiles_users
  has_many :users, :through => :device_profiles_users
  has_many :device_profiles_user_groups
  has_many :user_groups, :through => :device_profiles_user_groups
end
