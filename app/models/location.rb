class Location < ActiveRecord::Base
  attr_accessible :address, :country_id, :lattitude, :longitude, :site_name, :state_id, :google_earth_file
  belongs_to :state
  belongs_to :country
  has_attached_file :google_earth_file
  has_many :flare_deployments
  has_many :flare_specifications, :through => :flare_deployments
end
