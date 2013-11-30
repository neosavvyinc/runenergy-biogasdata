class Location < ActiveRecord::Base
  attr_accessible :address, :country_id, :lattitude, :longitude, :site_name, :state_id, :google_earth_file, :company_id, :user_group_ids, :user_ids
  belongs_to :state
  belongs_to :country
  belongs_to :company
  has_attached_file :google_earth_file
  has_many :flare_deployments
  has_many :flare_specifications, :through => :flare_deployments
  has_many :locations_monitor_classes
  has_many :monitor_classes, through: :locations_monitor_classes
  has_many :locations_user_groups
  has_many :user_groups, :through => :locations_user_groups
  has_many :locations_users
  has_many :users, :through => :locations_users

  def display_name
    site_name || "Unnamed #{state.name}, #{country.name}"
  end
end
