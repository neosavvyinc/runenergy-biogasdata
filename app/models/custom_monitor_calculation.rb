class CustomMonitorCalculation < ActiveRecord::Base
  attr_accessible :locations_monitor_class_id, :name, :value, :significant_digits
  belongs_to :locations_monitor_class

  include ActionView::Helpers::NumberHelper

  def self.parse(str, asset=nil, data=nil, prev_data=nil, q_prev_data = nil, date_taken_at = nil, prev_date_taken_at = nil)
    if str
      asset_params = str.scan(/asset\[(.*?)\]/).flatten
      data_params = str.scan(/data\[(.*?)\]/).flatten
      prev_data_params = str.scan(/prev_data\[(.*?)\]/).flatten
      q_prev_data_params = str.scan(/\[data\s*-\s*\d*\]\[(.*?)\]/).flatten

      #Scan and replace for asset attributes
      str.scan(/asset\[.*?\]/).each_with_index do |match, idx|
        replacement = asset.property_value_by_name(asset_params[idx]).try(:to_s)
        str = str.gsub(match, (replacement.blank? ? '0' : replacement))
      end

      #Parse data in case it is stringified
      if prev_data and prev_data.is_a? String
        prev_data = JSON.parse(prev_data)
      end
      if data and data.is_a? String
        data = JSON.parse(data)
      end

      #Scan the string for data attributes
      unless prev_data.nil?
        str.scan(/prev_data\[.*?\]/).each_with_index do |match, idx|
          replacement = prev_data[prev_data_params[idx]].to_s
          str = str.gsub(match, (replacement.blank? ? '0' : replacement))
        end
      end
      unless data.nil?
        str.scan(/data\[.*?\]/).each_with_index do |match, idx|
          replacement = data[data_params[idx]].to_s
          str = str.gsub(match, (replacement.blank? ? '0' : replacement))
        end
      end
      unless q_prev_data.nil?
        str.scan(/\[data\s*-\s*\d*\]\[.*?\]/).each_with_index do |match, idx|
          my_data = q_prev_data[match.scan(/-\s*\d*/).first.gsub(/\s/, '')]
          replacement = my_data.nil? ? nil : my_data[q_prev_data_params[idx]].to_s
          str = str.gsub(match, (replacement.blank? ? '0' : replacement))
        end
      end

      #Add the days field
      str = str.gsub(/\[days\]/, ((date_taken_at and prev_date_taken_at) ?
          Time.diff(date_taken_at, prev_date_taken_at, '%d')[:diff].gsub(/\sdays|\sday/, '') :
          '0')
      )

      begin
        eval(str)
      rescue Exception => e
        0
      end
    else
      raise 'You must pass in a string in order to parse a custom monitor calculation'
    end
  end

  def parse(asset = nil, data = nil, prev_data=nil, q_prev_data = nil, date_taken_at = nil, prev_data_taken_at = nil)
      number_with_precision(CustomMonitorCalculation.parse(value, asset, data, prev_data, q_prev_data, date_taken_at, prev_data_taken_at), precision: significant_digits || 2)
  end

  def requires_previous_reading?
    value.try(:include?, 'prev_data') or false
  end

  def requires_quantified_previous_reading?
    (not value.try(:match, /\[data\s*-\s*\d*\]\[.*?\]/).nil?)
  end

  def previous_data_indices
    value.scan(/\[data\s*-\s*\d*\]\[.*?\]/).map { |match| match.scan(/-\s*\d*/).first.gsub(/\s/, '') }
  end

  def requires_date_interval?
    value.try(:include?, '[days]') or false
  end
end
