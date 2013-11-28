class UserGroupsUser < ActiveRecord::Base
  attr_accessible :user_group_id, :user_id
  belongs_to :user_group
  belongs_to :user
end
