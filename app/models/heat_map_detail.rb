class HeatMapDetail < ActiveRecord::Base
  attr_accessible :asset_id, :symbol_id, :x, :y
  belongs_to :asset

  extend ActionView::Helpers::NumberHelper

  def self.asset_map(options = {})
    unless options[:locations_monitor_class].nil?
      options[:location] = options[:locations_monitor_class].location
      options[:monitor_class] = options[:locations_monitor_class].monitor_class
    end

    Asset.where(:location_id => options[:location].id,
                :monitor_class_id => options[:monitor_class].id).
        map { |a| self.asset_row(a) }
  end

  def self.asset_row(asset)
    {
        x: asset.heat_map_detail.try(:x),
        y: asset.heat_map_detail.try(:y),
        id: asset.id,
        uid: asset.unique_identifier,
        label: asset.unique_identifier
    }
  end

  def self.reading_map(options = {})
    unless options[:locations_monitor_class].nil?
      options[:location] = options[:locations_monitor_class].location
      options[:monitor_class] = options[:locations_monitor_class].monitor_class
    end

    Asset.where(:location_id => options[:location].id,
                :monitor_class_id => options[:monitor_class].id).
        map { |a| self.reading_row(a, options[:monitor_point], options[:start_date], options[:end_date]) }.
        compact
  end

  def self.reading_row(asset, monitor_point, start_date = nil, end_date = nil)
    readings = Reading.where(:asset_id => asset.id)
    unless start_date.nil?
      readings = readings.where('taken_at >= ?', start_date)
    end
    unless end_date.nil?
      readings = readings.where('taken_at <= ?', end_date)
    end
    readings = readings.map { |r| JSON.parse(r.data)[monitor_point.name].try(:to_f) }.reject(&:blank?).compact

    unless readings.nil? or readings.empty?
      begin
        {
            x: asset.heat_map_detail.try(:x),
            y: asset.heat_map_detail.try(:y),
            count: number_with_precision(readings.reduce(:+) / readings.size, precision: 2)
        }
      rescue Exception => e
        nil
      end
    else
      nil
    end
  end

end
