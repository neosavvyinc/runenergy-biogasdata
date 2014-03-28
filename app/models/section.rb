class Section < ActiveRecord::Base
  attr_accessible :location_id, :name, :asset_ids
  belongs_to :location
  has_many :assets
  has_many :readings, :through => :assets

  def self.lazy_load(options)
    Section.where(options).first || Section.create(options)
  end

  def display_name
    unless location.nil?
      "#{location.site_name} - #{name}"
    else
      "No Location Specified - #{name}"
    end
  end
end
