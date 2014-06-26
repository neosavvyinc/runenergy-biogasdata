class ColumnConversionMapping < ActiveRecord::Base
  attr_accessible :from, :ignored_column_or_conversion_id, :to
end
