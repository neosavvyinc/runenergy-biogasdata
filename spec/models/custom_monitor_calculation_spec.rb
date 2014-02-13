require 'spec_helper'

describe CustomMonitorCalculation do
  asset = nil, reading = nil
  
  before(:each) do
    height = FactoryGirl.create(:asset_property, :name => 'Height')
    weight = FactoryGirl.create(:asset_property, :name => 'Weight Long')
    asset = FactoryGirl.create(:asset)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => height, :value => 15)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => weight, :value => -100.3)
    reading = FactoryGirl.create(:reading, :data => {'Balance Gas' => 78, 'Methane' => 18, 'Toxic Waste' => 1010.5, 'Sub' => ''})
  end

  describe 'self.parse' do

    it 'should throw an error if not passed a string' do
      expect {
        CustomMonitorCalculation.parse(nil)
      }.to raise_error
    end

    it 'should be able to work with just a simple expression that has nothing with asset or data' do
      CustomMonitorCalculation.parse('5 * 9 - 10').should eq(35)
    end

    it 'should be able to grab a property off of just an asset' do
      CustomMonitorCalculation.parse('asset[Height] - asset[Weight Long]', asset).should eq(115.3)
    end

    it 'should be able to grab properties off of data only' do
      CustomMonitorCalculation.parse('15 * data[Balance Gas] - 109', nil, reading.data).should eq(1061)
    end

    it 'should be able to work with data and asset properties' do
      CustomMonitorCalculation.parse('(15 * data[Methane] - 109) / asset[Height]', asset, reading.data).should eq(10)
    end

    it 'should play nice with an empty data param' do
      CustomMonitorCalculation.parse('data[Sun] / 50', nil, reading.data).should eq(0)
    end

    it 'should play nice with an empty asset param' do
      CustomMonitorCalculation.parse('asset[Something Else] * 500', asset).should eq(0)
    end

    it 'should return a 0 if the parsing fails' do
      CustomMonitorCalculation.parse('Time * Something Else / Hello').should eq(0)
    end
    
  end

  describe 'parse' do
    let :custom_monitor_calculation do
      FactoryGirl.create(:custom_monitor_calculation, :value => '5 + .1234765')
    end

    it 'should just run parse and use a precision of two by default' do
      custom_monitor_calculation.parse.should eq('5.12')
    end

    it 'should use the significant digit precision, otherwise' do
      custom_monitor_calculation.significant_digits = 4
      custom_monitor_calculation.parse.should eq('5.1234')
    end
  end
  
end