require 'spec_helper'

describe MonitorPoint do

  let :location do
    FactoryGirl.create(:location)
  end

  let :monitor_point do
    FactoryGirl.create(:monitor_point, :name => 'Methane Gas')
  end

  let :monitor_limit do
    FactoryGirl.create(:deluxe_monitor_limit, :monitor_point => monitor_point, :location => location)
  end

  before(:each) do
    monitor_limit.should_not be_nil
  end

  describe 'self.lazy_load_from_schema' do

    it 'should grab the monitor point from params if it exists' do
      MonitorPoint.lazy_load_from_schema({:name => 'Methane Gas'}).id.should eq(monitor_point.id)
    end

    it 'should create the monitor_point otherwise' do
      MonitorPoint.lazy_load_from_schema({:name => 'Methane Gas 20'}).id.should_not eq(monitor_point.id)
    end

    it 'should play nice with the upper limit and lower limit params' do
      MonitorPoint.lazy_load_from_schema({:name => 'Methane Gas', :upper_limit => 78, :lower_limit => 15}).id.should eq(monitor_point.id)
    end

    it 'should try and create a monitor limit if none is found, and a site_id is provided' do
      mp = MonitorPoint.lazy_load_from_schema({:name => 'Methane Gas', :upper_limit => 78, :lower_limit => 15, :location_id => location.id})
      MonitorLimit.last.location_id.should eq(location.id)
      MonitorLimit.last.monitor_point_id.should eq(mp.id)
    end
    
  end

  describe 'monitor_limit_for_location' do

    it 'should return the monitor_limit found if it is not null' do
      monitor_point.monitor_limit_for_location(location.id).should eq(monitor_limit)
    end

    it 'should not return a monitor_limit if it does not match the location' do
      monitor_point.monitor_limit_for_location(FactoryGirl.create(:location).id).should be_nil
    end

    it 'should not return a monitor_limit if it does not match the monitor_point' do
      FactoryGirl.create(:monitor_point).monitor_limit_for_location(location.id).should be_nil
    end

  end
  
  describe 'snake_name' do
    it 'should return a snake case version of the name' do
      monitor_point.snake_name.should eq('methane_gas')
    end
  end
end
