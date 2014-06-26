class IgnoredColumnOrConversion < ActiveRecord::Base
  attr_accessible :column_name, :convert_to, :ignore, :column_conversion_mappings_attributes, :monitor_class_ids
  has_many :ignored_columns_or_conversions_monitor_classes
  has_many :monitor_classes, :through => :ignored_columns_or_conversions_monitor_classes
  has_many :column_conversion_mappings

  accepts_nested_attributes_for :column_conversion_mappings, :allow_destroy => true

  def self.process(data, monitor_class_id)
    unless monitor_class_id.nil? or data.nil?
      iccs = MonitorClass.find(monitor_class_id).ignored_column_or_conversions
      iccs.each do |icc|
        if icc.ignore
          data.delete(icc.column_name)
        else
          if icc.convert_to and icc.column_name != icc.convert_to
            data[icc.convert_to] = data[icc.column_name]

            #Get rid of old column
            data.delete(icc.column_name)
          end

          column_value_map = icc.column_value_map
          if column_value_map and column_value_map[data[icc.convert_to]]
            data[icc.convert_to] = column_value_map[data[icc.convert_to]]
          end
        end
      end
      data
    else
      data
    end
  end

  def column_value_map
    unless self.column_conversion_mappings.empty?
      map = {}
      self.column_conversion_mappings.each do |ccm|
        map[ccm.from] = ccm.to
      end
      map
    else
      nil
    end
  end

  def display_name
    if self.column_name and self.convert_to
      "#{self.column_name} > #{self.convert_to}"
    elsif self.column_name
      self.column_name
    else
      'None specified'
    end
  end
end
