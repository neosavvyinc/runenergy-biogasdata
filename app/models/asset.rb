class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id, :location_id, :monitor_class_id, :monitor_point_ids, :unique_identifier
  belongs_to :location
  belongs_to :section
  belongs_to :monitor_class
  has_many :readings

  def self.lazy_load(location_id, monitor_class_id, unique_identifier)
    Asset.where(:location_id => location_id,
                :monitor_class_id => monitor_class_id,
                :unique_identifier => unique_identifier).first or
        Asset.create(:location_id => location_id,
                     :monitor_class_id => monitor_class_id,
                     :unique_identifier => unique_identifier)
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
