class AttributeNameMapping < ActiveRecord::Base
  attr_accessible :applies_to_class, :attribute_name, :display_name, :units, :significant_digits
end
