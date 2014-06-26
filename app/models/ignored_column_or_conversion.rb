class IgnoredColumnOrConversion < ActiveRecord::Base
  attr_accessible :column_name, :convert_to, :ignore, :column_conversion_mappings_attributes
  has_many :ignored_columns_or_conversions_monitor_classes
  has_many :monitor_classes, :through => :ignored_columns_or_conversions_monitor_classes
  has_many :column_conversion_mappings

  accepts_nested_attributes_for :column_conversion_mappings, :allow_destroy => true

  def display_name
    if self.column_name and self.convert_to
      "#{self.column_name} > #{self.convert_to}"
    else
      'None specified'
    end
  end
end
