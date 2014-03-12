require 'spec_helper'

describe CustomMonitorCalculation do
  asset = nil, prev_reading = nil, reading = nil

  before(:each) do
    height = FactoryGirl.create(:asset_property, :name => 'Height')
    weight = FactoryGirl.create(:asset_property, :name => 'Weight Long')
    asset = FactoryGirl.create(:asset)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => height, :value => 15)
    asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => weight, :value => -100.3)
    prev_reading = FactoryGirl.create(:reading, :data => {'Balance Gas' => -10.56, 'Methane' => 90.12, 'Toxic Waste' => 42, 'Sub' => '18.79'})
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

    it 'should play nice with prev_data only' do
      CustomMonitorCalculation.parse('prev_data[Sub] * 10', nil, nil, prev_reading.data).should be_within(0.001).of(187.9)
    end

    it 'should play nice with prev_data and an asset' do
      CustomMonitorCalculation.parse('prev_data[Sub] * 10 - asset[Height]', asset, nil, prev_reading.data).should be_within(0.001).of(172.9)
    end

    it 'should play nice with data and prev_data' do
      CustomMonitorCalculation.parse('data[Balance Gas] / prev_data[Balance Gas]', nil, reading.data, prev_reading.data).should be_within(0.001).of(-7.386)
    end

    it 'should play nice with asset, data, and prev_data' do
      CustomMonitorCalculation.parse('(data[Balance Gas] / prev_data[Balance Gas]) + asset[Weight Long]', asset, reading.data, prev_reading.data).should be_within(0.001).of(-107.686)
    end

  end

  describe 'parse' do
    let :custom_monitor_calculation do
      FactoryGirl.create(:custom_monitor_calculation, :value => '5 + 0.1234765')
    end

    it 'should just run parse and use a precision of two by default' do
      custom_monitor_calculation.parse.should eq('5.12')
    end

    it 'should use the significant digit precision, otherwise' do
      custom_monitor_calculation.significant_digits = 4
      custom_monitor_calculation.parse.should eq('5.1235')
    end
  end

  describe 'requires_previous_reading?' do

    it 'should return false for custom monitor calculations with no value defined' do
      custom_monitor_calculation = FactoryGirl.create(:custom_monitor_calculation, :value => nil)
      custom_monitor_calculation.requires_previous_reading?.should be_false
    end

    it 'should return false for custom monitor calculations with no prev_data in their values' do
      custom_monitor_calculation = FactoryGirl.create(:custom_monitor_calculation, :value => 'data[Something] - asset[Something Else]')
      custom_monitor_calculation.requires_previous_reading?.should be_false
    end

    it 'should return true for the custom_monitor_calculations that have prev_data in their values' do
      custom_monitor_calculation = FactoryGirl.create(:custom_monitor_calculation, :value => 'prev_data[Something] - asset[Something Else]')
      custom_monitor_calculation.requires_previous_reading?.should be_true
    end

  end

  describe 'requires_quantified_previous_reading?' do

    it 'should return false if the value does not contain quantified previous readings' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => 'data[Something] - asset[Something Else]').
          requires_quantified_previous_reading?.should be_false
    end

    it 'should return true if it contains one that has no spaces' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data-15][Something] - asset[Something Else]').
          requires_quantified_previous_reading?.should be_true
    end

    it 'should return true for another one with more spaces' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data -   4000][Something] - asset[Something Else]').
          requires_quantified_previous_reading?.should be_true
    end

    it 'should return false for a case with a plus' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data + 1][Something] - asset[Something Else]').
          requires_quantified_previous_reading?.should be_false
    end

  end
  
  describe 'previous_data_indices' do

    it 'should return the negative string values of the indices described in the data equations' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data-4000][Something] - asset[Something Else] + [data-10][Oxygen]').
          previous_data_indices.should eq(['-4000', '-10'])
    end

    it 'should remove spaces' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data -   4000][Something] - asset[Something Else] + [data - 10][Oxygen]').
          previous_data_indices.should eq(['-4000', '-10'])
    end

    it 'should not get throw off with normal data' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data -   59][Something] - asset[Something Else] * data[Oxymagic] + [data - 10][Oxygen]').
          previous_data_indices.should eq(['-59', '-10'])
    end

    it 'should not get thrown off with prev_data' do
      FactoryGirl.
          create(:custom_monitor_calculation, :value => '[data -   59][Something] - asset[Something Else] * prev_data[Oxymagic] + [data - 10][Oxygen]').
          previous_data_indices.should eq(['-59', '-10'])
    end
    
  end

end