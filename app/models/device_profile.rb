class DeviceProfile < ActiveRecord::Base
  attr_accessible :name, :uid
  has_many :device_profiles_users
  has_many :users, :through => :device_profiles_users
  has_many :device_profiles_user_groups
  has_many :user_groups, :through => :device_profiles_user_groups

  def unique_users
    (users + user_groups.collect { |ug| ug.users }.flatten(1)).uniq
  end
end
