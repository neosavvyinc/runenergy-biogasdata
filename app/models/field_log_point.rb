class FieldLogPoint < ActiveRecord::Base
  attr_accessible :name
  has_many :monitor_classes_field_log_points
  has_many :monitor_classes, through: :monitor_classes_field_log_points

  def self.RAIN_SINCE_PREVIOUS_READING
    self.find_or_create_by_name('Rain Since Previous Reading')
  end

  def snake_name
    name.gsub(/\s{1,}/, '_').downcase
  end

  def as_json(options={})
    super(options).merge(:snake_name => snake_name)
  end
end
