class LocationsMonitorClass < ActiveRecord::Base
  attr_accessible :location_id, :monitor_class_id, :monitor_point_ids, :column_cache, :deleted_column_cache
  belongs_to :location
  belongs_to :monitor_class
  has_many :monitor_points_locations_monitor_classes
  has_many :monitor_points, :through => :monitor_points_locations_monitor_classes

  validates_presence_of :location, :monitor_class

  def self.create_caches(location_id, monitor_class_id, column_mapping, deleted_columns)
    locations_monitor_class = LocationsMonitorClass.where(:location_id => location_id, :monitor_class_id => monitor_class_id).first
    if locations_monitor_class.nil?
      locations_monitor_class = LocationsMonitorClass.new(:location_id => location_id, :monitor_class_id => monitor_class_id)
    end
    locations_monitor_class.column_cache = column_mapping
    locations_monitor_class.deleted_column_cache = deleted_columns
    locations_monitor_class.save

    #Return value
    locations_monitor_class
  end

  def display_name
    "#{location.site_name} - #{monitor_class.name.pluralize}"
  end

  def as_json(options={})
    super(options).merge({
                             'column_cache' => JSON.parse(self.column_cache),
                             'deleted_column_cache' => JSON.parse(self.deleted_column_cache)
                         })
  end
end