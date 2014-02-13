class MonitorClass < ActiveRecord::Base
  attr_accessible :name, :monitor_point_ids, :field_log_point_ids, :asset_ids, :location_ids, :asset_property_ids, :asset_properties_attributes, :monitor_point_ordering
  has_many :readings
  has_many :monitor_classes_monitor_points
  has_many :monitor_points, through: :monitor_classes_monitor_points
  has_many :locations_monitor_classes
  has_many :locations, through: :locations_monitor_classes
  has_many :monitor_classes_field_log_points
  has_many :field_log_points, through: :monitor_classes_field_log_points
  has_many :asset_properties

  accepts_nested_attributes_for :asset_properties, :allow_destroy => true

  validates_each :monitor_point_ordering, allow_blank: true do |record, attr, value|
    points  = value.split(',').map {|p| p.strip}
    points.each do |p|
      if p != 'Date Time' and MonitorPoint.where(:name => p).first.nil? and CustomMonitorCalculation.where(:name => p).first.nil?
        record.errors.add attr, "#{p} is not a monitor point or custom calculation."
        break
      end
    end
  end

  def monitor_points_for_all_locations
    lmcs = LocationsMonitorClass.where(:monitor_class_id => self.id).
        collect { |lmc| lmc.monitor_points }.
        flatten
    unless lmcs.empty?
      lmcs
    else
      MonitorPoint.all
    end
  end

end
