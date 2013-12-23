class Asset < ActiveRecord::Base
  attr_accessible :name, :section_id, :monitor_class_ids, :monitor_point_ids
  belongs_to :section

  #This may be able to go away
  has_many :assets_monitor_classes
  has_many :monitor_classes, through: :assets_monitor_classes

  has_many :assets_monitor_points
  has_many :monitor_points, :through => :assets_monitor_points
  has_many :readings

  def available_sections
    if not @location.nil?
      @location.sections
    elsif not section.nil?
      section.location.sections
    else
      Section.all
    end
  end

  def as_json(options={})
    super(options).merge({
                             :monitor_points => self.monitor_points.as_json
                         })
  end
end
