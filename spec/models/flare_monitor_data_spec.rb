require "spec_helper"

describe FlareMonitorData do

  let :primary_flare_specification do
    FactoryGirl.create(:flare_specification)
  end

  let :flare_data_a do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => -1, :lfg_temperature => 47.76, :flare_specification => primary_flare_specification)
  end

  let :flare_data_b do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => 2, :lfg_temperature => 10050.23, :date_time_reading => Time.new)
  end

  let :flare_data_c do
    FactoryGirl.create(:flare_monitor_data, :blower_speed => 0, :lfg_temperature => 6, :flare_specification => primary_flare_specification)
  end

  let :attribute_name_mapping_a do
    FactoryGirl.create(:attribute_name_mapping, :attribute_name => "flame_temperature", :display_name => "Flame Temperature + Something", :column_weight => 8, :significant_digits => 42)
  end

  before(:each) do
    flare_data_a.should_not be_nil
    flare_data_b.should_not be_nil
    flare_data_c.should_not be_nil
    attribute_name_mapping_a.should_not be_nil
  end

  describe "self" do
    describe "display_object_for_field" do
      it 'should return the display_name property of the attribute found' do
        FlareMonitorData.display_object_for_field("flame_temperature").should eq(attribute_name_mapping_a)
      end

      it 'should return a blank string if the attribute is not found' do
        FlareMonitorData.display_object_for_field(:touchdowns).should eq({})
      end
    end

    describe "column_weight_for_field" do
      it 'should return undefined if the column weight is not defined' do
        FlareMonitorData.column_weight_for_field("three_pointers").should be_nil
      end

      it 'should return and cache the column weight if it exists' do
        FlareMonitorData.column_weight_for_field("flame_temperature").should eq(8)
        FlareMonitorData.class_variable_get(:@@column_weights)[:flame_temperature].should eq(8)
      end
    end

    describe "significant_digits_for_field" do
      it 'should return nil if the the field is not defined' do
        FlareMonitorData.significant_digits_for_field("green_indian_fusion").should be_nil
      end

      it 'should return and cache the significant digits if the field is defined' do
        FlareMonitorData.significant_digits_for_field("flame_temperature").should eq(42)
        FlareMonitorData.class_variable_get(:@@significant_digits)[:flame_temperature].should eq(42)
      end
    end

    describe "filter_data" do
      it 'should filter and sort when flareSpecificationId is specified' do
        query = FlareMonitorData.filter_data({'flareSpecificationId' => primary_flare_specification.id})
        query.length.should eq(2)
        query.each do |fmd|
          (fmd == flare_data_a or fmd == flare_data_c).should be_true
        end
      end

      it 'should return all FlareMonitorData if no valid filter is specified' do
        query = FlareMonitorData.filter_data({})
        query.length.should eq(3)
      end
    end

    describe "with_filters" do
      it 'should return the original query if no filters are passed in' do
        query = FlareMonitorData.all
        FlareMonitorData.with_filters(query).should eq(query)
      end

      it 'should return the original query if empty filters are passed in' do
        query = FlareMonitorData.all
        FlareMonitorData.with_filters(query, {}).should eq(query)
      end

      it 'should match the filters to the columns' do
        query = FlareMonitorData.with_filters(FlareMonitorData, {:blower_speed => "> -1", :lfg_temperature => "<= 7"})
        query.length.should eq(1)
        query.first.should eq(flare_data_c)
      end
    end
  end

  describe "instance" do
    describe "energy" do
      it 'should return 0 when methane is nil' do
        flare_data_a.methane = nil
        flare_data_a.energy.should eq(0)
      end

      it 'should multiply methane by the NET_HEATING_VALUE constant (0.0339)' do
        flare_data_a.methane = 5
        flare_data_a.energy.should be_within(0.01).of(0.1695)
      end
    end

    describe "methane_tonne" do
      it 'should return 0 when methane is nil' do
        flare_data_c.methane = nil
        flare_data_c.methane_tonne.should eq(0)
      end

      it 'should multiply methane by the METHANE_NHV_VALUE constant (50)' do
        flare_data_c.methane = 374.63
        flare_data_c.methane_tonne.should be_within(0.01).of(0.254)
      end
    end

    describe "as_json" do
      it 'should specify the flare_specification_id as the flare_unique_identifier of the specification' do
        flare_data_c.as_json['flare_specification_id'].should eq(primary_flare_specification.flare_unique_identifier)
      end

      it 'should specify a formatted string for the date_time_reading' do
        flare_data_b.as_json['date_time_reading'].should be_an_instance_of(String)
      end
    end

    describe "as_json_significant_digits" do

    end

    describe "as_json_from_keys" do
      it 'should return the values for the specified keys' do
        flare_data_a.as_json_from_keys(['lfg_temperature', 'flare_specification_id']).should eq([flare_data_a.lfg_temperature, primary_flare_specification.flare_unique_identifier])
      end

      it 'should play nice with options as well' do
        flare_data_a.methane = 24
        flare_data_a.as_json_from_keys(['blower_speed', 'flare_specification_id', :energy], {:methods => [:energy]}).should eq([flare_data_a.blower_speed, primary_flare_specification.flare_unique_identifier, flare_data_a.energy])
      end
    end
  end

end