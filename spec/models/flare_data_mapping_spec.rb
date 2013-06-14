require 'spec_helper'

describe FlareDataMapping do

  let :empty_data_mapping do
    FactoryGirl.create(:flare_data_mapping, :name => "MY Data Mapping", :inlet_pressure_column => "This Is A Name", :methane_column => "Methane Column (units)")
  end

  describe "before_save" do
    describe "sanitize_values" do
      it "should sanitize the attributes set on the object" do
        empty_data_mapping.blower_speed_column = "Blower Speed Column"
        empty_data_mapping.flame_temperature_column = "Date 5 Column-Something (units)"
        empty_data_mapping.save!
        new_mapping = FlareDataMapping.find(empty_data_mapping.id)
        new_mapping.blower_speed_column.should eq("blower_speed_column")
        new_mapping.flame_temperature_column.should eq("date_5_column-something_(units)")
      end
    end
  end

  describe "values_to_attributes" do

    it 'should return the set values in a reverse map' do
      empty_data_mapping.values_to_attributes.should eq({
                                                            'this_is_a_name' => :inlet_pressure,
                                                            'methane_column_(units)' => :methane
                                                        })
    end

    it 'should return an empty map if there are no set values' do
      empty_data_mapping.inlet_pressure_column = nil
      empty_data_mapping.methane_column = nil
      empty_data_mapping.save!
      empty_data_mapping.values_to_attributes.should eq({})
    end
  end
end
