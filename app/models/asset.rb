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

  def asset_properties
    kv = {}
    asset_property_values.each do |apv|
      unless apv.asset_property.nil?
        kv[apv.asset_property.name] = apv.value
      end
    end
    kv
  end

  def display_name
    "#{location.try(:site_name) || 'No Location'}, #{monitor_class.try(:name) || 'No Class'}: #{unique_identifier}"
  end

  def property_value_by_name(name)
    asset_property_values.joins(:asset_property)
    .where('asset_properties.name' => name.to_s).first.try(:value)
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
