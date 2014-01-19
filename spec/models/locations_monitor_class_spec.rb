require 'spec_helper'

describe LocationsMonitorClass do

  let :location do
    FactoryGirl.create(:location, :site_name => 'Tom Landfill')
  end

  let :another_location do
    FactoryGirl.create(:location, :site_name => 'George Landfill')
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class, :name => 'Shorty')
  end

  let :locations_monitor_class do
    FactoryGirl.create(:locations_monitor_class,
                       :location => location,
                       :monitor_class => monitor_class,
                       :column_cache => {:name => 'George'}.to_json,
                       :deleted_column_cache => {:age => 17}.to_json
    )
  end

  before(:each) do
    locations_monitor_class.should_not be_nil
  end

  describe 'self.create_caches' do
    it 'should be able to work with an existing LocationsMonitorClass' do
      lmc = LocationsMonitorClass.create_caches(location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'huey')
      lmc.id.should eq(locations_monitor_class.id)
      lmc.column_cache.should eq({:name => 'Stevie'}.to_json)
      lmc.deleted_column_cache.should eq({:hand => true}.to_json)
      lmc.asset_column_name.should eq('huey')
    end

    it 'should be able to create a new LocationsMonitorClass' do
      lmc = LocationsMonitorClass.create_caches(another_location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'steve')
      lmc.column_cache.should eq({:name => 'Stevie'}.to_json)
      lmc.deleted_column_cache.should eq({:hand => true}.to_json)
      lmc.asset_column_name.should eq('steve')
    end
  end

  describe 'display_name' do
    it 'should return the location and then pluralized monitor class name' do
      locations_monitor_class.display_name.should eq('Tom Landfill - Shorties')
    end
  end

  describe 'as_json' do
    it 'should parse out json for the column_cache' do
      locations_monitor_class.as_json['column_cache'].should eq({'name' => 'George'})
    end

    it 'should parse out json for the deleted_column_cache' do
      locations_monitor_class.as_json['deleted_column_cache'].should eq({'age' => 17})
    end
  end

end