require "spec_helper"

describe AttributeNameMapping do

  describe "self.calculation_headings" do
    it 'should return the expected calculation headings' do
      AttributeNameMapping.calculation_headings.should eq [
       {:display_name => "Energy GJ/h", :units => "NHV", :significant_digits => 3},
       {:display_name => "Methane", :units => "tonne/hour", :significant_digits => 3},
     ]
    end
  end

end