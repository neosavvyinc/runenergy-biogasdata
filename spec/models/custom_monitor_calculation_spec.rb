require 'spec_helper'

describe CustomMonitorCalculation do
  asset = nil, reading = nil
  
  before(:each) do
    height = FactoryGirl.create(:asset_property, :name => 'Height')
    weight = FactoryGirl.create(:asset_property, :name => 'Weight Long')
    asset = FactoryGirl.create(:asset)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => height, :value => 15)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => weight, :value => -100.3)
    reading = FactoryGirl.create(:reading, :data => {'Balance Gas' => 78, 'Methane' => 18, 'Toxic Waste' => 1010.5})
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
    
  end
  
end