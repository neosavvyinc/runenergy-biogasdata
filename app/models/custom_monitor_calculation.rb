class CustomMonitorCalculation < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :name, :value, :significant_digits
  belongs_to :locations_monitor_class

  include ActionView::Helpers::NumberHelper

  def self.parse(str, asset=nil, data=nil)
    if str
      asset_params = str.scan(/asset\[(.*?)\]/).flatten
      data_params = str.scan(/data\[(.*?)\]/).flatten

      #Scan and replace for asset attributes
      str.scan(/asset\[.*?\]/).each_with_index do |match, idx|
        replacement = asset.property_value_by_name(asset_params[idx]).try(:to_s)
        str = str.gsub(match, (replacement.blank? ? '0' : replacement))
      end

      #Parse data in case it is stringified
      if data and data.is_a? String
        data = JSON.parse(data)
      end

      #Scan the string for data attributes
      str.scan(/data\[.*?\]/).each_with_index do |match, idx|
        replacement = data[data_params[idx]].to_s
        str = str.gsub(match, (replacement.blank? ? '0' : replacement))
      end

      begin
        eval(str)
      rescue Exception => e
        0
      end
    else
      raise 'You must pass in a string in order to parse a custom monitor calculation'
    end
  end

  def parse(asset = nil, data = nil)
    number_with_precision(CustomMonitorCalculation.parse(value, asset, data), precision: significant_digits || 2)
  end
end
