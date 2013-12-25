class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id, :monitor_class_id, :monitor_point_ids
  belongs_to :section
  belongs_to :monitor_class
  has_many :assets_monitor_points
  has_many :monitor_points, :through => :assets_monitor_points
  has_many :readings

  def as_json(options={})
    super(options).merge({
                             :monitor_points => self.monitor_points.as_json
                         })
  end
end
