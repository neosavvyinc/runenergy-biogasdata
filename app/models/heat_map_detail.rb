class HeatMapDetail < ActiveRecord::Base
  attr_accessible :asset_id, :symbol_id, :x, :y
  belongs_to :asset

  extend ActionView::Helpers::NumberHelper

  def self.asset_row(asset)
    {
        x: asset.heat_map_detail.try(:x),
        y: asset.heat_map_detail.try(:y),
        id: asset.id,
        uid: asset.unique_identifier
    }
  end

  def self.reading_row(asset, monitor_point, start_date = nil, end_date = nil)
    readings = Reading.where(:asset_id => asset.id)
    unless start_date.nil?
      readings = readings.where('taken_at >= ?', start_date)
    end
    unless end_date.nil?
      readings = readings.where('taken_at <= ?', end_date)
    end
    readings = readings.map { |r| JSON.parse(r.data)[monitor_point.name] }.
        compact
    {
        x: asset.heat_map_detail.try(:x),
        y: asset.heat_map_detail.try(:y),
        count: number_with_precision(
            readings.reduce(:+) / readings.size,
            precision: 2
        )
    }
  end

end
