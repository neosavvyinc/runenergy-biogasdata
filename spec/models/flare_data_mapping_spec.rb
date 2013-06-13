require 'spec_helper'

describe FlareDataMapping do

  before(:each) do
    FactoryGirl.find_definitions
  end

  let :empty_data_mapping do
    FactoryGirl.create(:flare_data_mapping)
  end

  describe "before_save" do
    describe "sanitize_values" do
      it "should sanitize the attributes set on the object" do
        empty_data_mapping.blower_speed_column = "Blower Speed Column"
        empty_data_mapping.date_reading_column = "Date 5 Column-Something (units)"
        empty_data_mapping.save!
        new_mapping = FlareDataMapping.find(empty_data_mapping.id)
        new_mapping.blower_speed_column.should eq("blower_speed_column")
        new_mapping.date_reading_column.should eq("date_5_column-something_(units)")
      end
    end
  end
end
