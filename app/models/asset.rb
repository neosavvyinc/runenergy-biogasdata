class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id, :location_id, :monitor_class_id, :monitor_point_ids, :unique_identifier, :asset_property_values_attributes
  belongs_to :location
  belongs_to :section
  belongs_to :monitor_class
  has_many :readings
  has_many :asset_property_values

  accepts_nested_attributes_for :asset_property_values, :allow_destroy => true

  def self.lazy_load(location_id, monitor_class_id, unique_identifier)
    Asset.where(:location_id => location_id,
                :monitor_class_id => monitor_class_id,
                :unique_identifier => unique_identifier).first or
        Asset.create(:location_id => location_id,
                     :monitor_class_id => monitor_class_id,
                     :unique_identifier => unique_identifier)
  end

  def display_name
    "#{location.try(:site_name) || 'No Location'}, #{monitor_class.try(:name) || 'No Class'}: #{unique_identifier}"
  end

  def available_sections
    if not @location.nil?
      @location.sections
    elsif not section.nil?
      section.location.sections
    else
      Section.all
    end
  end

end
