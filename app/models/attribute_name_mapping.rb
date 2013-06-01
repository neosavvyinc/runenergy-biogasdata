class AttributeNameMapping < ActiveRecord::Base
  attr_accessible :applies_to_class, :attribute_name, :display_name, :units, :significant_digits

  def self.calculation_headings
    [
        {:display_name => "Energy GJ/h (NHV)", :units => "NHV", :significant_digits => 3},
        {:display_name => "Methane (tonne)", :units => "tonne", :significant_digits => 3},
        {:display_name => "CO2 eqiv", :units => "eqiv", :significant_digits => 3}
    ]
  end

end
