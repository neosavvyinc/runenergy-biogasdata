class CustomMonitorCalculation < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :value
  belongs_to :locations_monitor_class

  def self.parse(str, asset, data)
    if str
      asset_params = /asset\[(.*?)\]/.match(str).values_at(* a.each_index.select { |i| i.odd? })
      data_params = /data\[(.*?)\]/.match(str).values_at(* a.each_index.select { |i| i.odd? })
    else
      raise 'You must pass in a string in order to parse a custom monitor calculation'
    end
  end
end
