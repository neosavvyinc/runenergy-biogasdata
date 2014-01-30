class MonitorPoint < ActiveRecord::Base
  include MappingHelp

  attr_accessible :name, :unit
  has_many :monitor_classes_monitor_points
  has_many :monitor_classes, through: :monitor_classes_monitor_points
  has_many :monitor_limits
  has_many :assets_monitor_points
  has_many :assets, :through => :assets_monitor_points

  def self.lazy_load_from_schema(params)
    mp_params = params.reject { |k, v| [:location_id, :upper_limit, :lower_limit].include?(k) }
    mp = self.where(mp_params).first || MonitorPoint.create(mp_params)
    if params[:location_id] and MonitorLimit.where(:monitor_point_id => mp.id, :location_id => params[:location_id]).first.nil?
      ml_params = params.reject { |k, v| not [:location_id, :upper_limit, :lower_limit].include?(k) }
      MonitorLimit.create({:monitor_point_id => mp.id}.merge(ml_params))
    end
    mp
  end

  def snake_name
    name.gsub(/\s{1,}/, '_').downcase
  end
end
