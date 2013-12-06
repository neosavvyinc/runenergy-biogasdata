class Section < ActiveRecord::Base
  attr_accessible :location_id, :name
  belongs_to :location
  has_many :assets

  def display_name
    unless location.nil?
      "#{location.site_name} - #{name}"
    else
      "No Location Specified - #{name}"
    end
  end
end
