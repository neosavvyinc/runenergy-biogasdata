require 'spec_helper'

describe Asset do

  let :location do
    FactoryGirl.create(:deluxe_location)
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :other_location do
    FactoryGirl.create(:location)
  end

  let :asset do
    FactoryGirl.create(:asset, :location => location, :monitor_class => monitor_class, :unique_identifier => '78HFG')
  end

  before(:each) do
    asset.should_not be_nil
  end

  describe 'self.lazy_load' do

    it 'should grab the object from db if it exists' do
      Asset.lazy_load(location.id, monitor_class.id, '78HFG').id.should eq(asset.id)
    end

    it 'should create the object if it does not exist in db' do
      Asset.lazy_load(other_location.id, monitor_class.id, '78HFG').id.should_not eq(asset.id)
    end

    it 'should create the object if it doesnt exist via other field' do
      Asset.lazy_load(location.id, monitor_class.id, 'NOTRIGHT').id.should_not eq(asset.id)
    end

  end

  describe 'asset_properties' do

    before(:each) do
      name = FactoryGirl.create(:asset_property, :name => 'Name')
      height = FactoryGirl.create(:asset_property, :name => 'Height')
      FactoryGirl.create(:asset_property_value, :asset => asset, :value => 5446, :asset_property => height)
      FactoryGirl.create(:asset_property_value, :asset => asset, :value => 'George', :asset_property => name)
    end

    it 'should return an empty hash if there are no asset_properties defined' do
      FactoryGirl.create(:asset).asset_properties.should eq({})
    end

    it 'should return the asset_property values with their property names as keys' do
      asset.asset_properties.should eq({
          'Name' => 'George',
          'Height' => '5446'
                                                })
    end

  end

  describe 'display_name' do
    it 'should be good at including the location and monitor class' do
      asset.display_name.should eq("#{location.site_name}, #{monitor_class.name}: 78HFG")
    end

    it 'should have a no location case' do
      asset.location = nil
      asset.display_name.should eq("No Location, #{monitor_class.name}: 78HFG")
    end

    it 'should have no a monitor class case' do
      asset.monitor_class = nil
      asset.display_name.should eq("#{location.site_name}, No Class: 78HFG")
    end
  end

  describe 'property_value_by_name' do
    height = nil, depth = nil, color = nil

    before(:each) do
      height = FactoryGirl.create(:asset_property, :name => 'Height')
      depth = FactoryGirl.create(:asset_property, :name => 'Depth')
      color = FactoryGirl.create(:asset_property, :name => 'Color')
      asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => height, :value => 56)
      asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => color, :value => nil)
    end

    it 'should return nil when the property the property does not exist' do
      asset.property_value_by_name('Weight').should be_nil

    end

    it 'should return nil when the value does not exist' do
      asset.property_value_by_name('Depth').should be_nil
    end

    it 'should return nil when there is no value assigned' do
      asset.property_value_by_name('Color').should be_nil
    end

    it 'should return the value when it is set' do
      asset.property_value_by_name('height').should eq('56')
    end

    it 'should return the value when it is set and passed a symbol' do
      asset.property_value_by_name(:height).should eq('56')
    end

  end

end
