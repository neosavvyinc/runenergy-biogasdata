class CustomMonitorCalculation < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :value
  belongs_to :locations_monitor_class

  def self.parse(str, asset=nil, data=nil)
    if str
      asset_params = str.scan(/asset\[(.*?)\]/).flatten
      data_params = str.scan(/data\[(.*?)\]/).flatten

      #Scan and replace for asset attributes
      str.scan(/asset\[.*?\]/).each_with_index do |match, idx|
        str = str.gsub(match, asset.property_value_by_name(asset_params[idx]).to_s)
      end

      #Parse data in case it is stringified
      if data and data.is_a? String
        data = JSON.parse(data)
      end

      #Scan the string for data attributes
      str.scan(/data\[.*?\]/).each_with_index do |match, idx|
        str = str.gsub(match, data[data_params[idx]].to_s)
      end
      eval(str)
    else
      raise 'You must pass in a string in order to parse a custom monitor calculation'
    end
  end
end
