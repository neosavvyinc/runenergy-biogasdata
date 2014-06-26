class ColumnConversionMapping < ActiveRecord::Base
  attr_accessible :from, :ignored_column_or_conversion_id, :to
  belongs_to :ignored_column_or_conversion
end
