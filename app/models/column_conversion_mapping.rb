class ColumnConversionMapping < ActiveRecord::Base
  attr_accessible :from, :ignored_column_or_conversion_id, :to, :comment_entry
  belongs_to :ignored_column_or_conversion
end
