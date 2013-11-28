class UserGroup < ActiveRecord::Base
  attr_accessible :name
  has_many :user_groups_users
  has_many :users, :through => :user_groups_users
  has_many :device_profiles_user_groups
  has_many :device_profiles, :through => :device_profiles_user_groups
end
