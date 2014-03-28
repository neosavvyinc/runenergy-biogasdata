class Location < ActiveRecord::Base
  attr_accessible :address, :country_id, :lattitude, :longitude, :site_name, :state_id, :google_earth_file, :company_id, :user_group_ids, :user_ids, :monitor_class_ids, :section_ids
  belongs_to :state
  belongs_to :country
  belongs_to :company
  has_attached_file :google_earth_file
  has_many :sections
  has_many :readings, :through => :sections
  has_many :flare_deployments
  has_many :flare_specifications, :through => :flare_deployments
  has_many :locations_monitor_classes
  has_many :monitor_classes, through: :locations_monitor_classes
  has_many :locations_user_groups
  has_many :user_groups, :through => :locations_user_groups
  has_many :locations_users
  has_many :users, :through => :locations_users
  has_many :assets

  validates_presence_of :site_name

  def assets_monitored_within_date_range(start_date_time, end_date_time)
    Reading.where('taken_at >= ? AND taken_at <= ?', start_date_time, end_date_time).map {|r| r.asset}.uniq
  end

  def display_name
    site_name || "Unnamed #{state.name}, #{country.name}"
  end

  def monitor_classes_with_points
    monitor_classes.try(:as_json, {:include => [:monitor_points, :field_log_points]})
  end

end
