require 'spec_helper'

describe MappingHelp do

  let :monitor_point_a do
    FactoryGirl.create(:monitor_point, :name => 'George')
  end

  let :monitor_point_b do
    FactoryGirl.create(:monitor_point, :name => 'Steve')
  end

  before(:each) do
    monitor_point_a.should_not be_nil
    monitor_point_b.should_not be_nil
  end

  describe 'map_with_key' do

    it 'should map to the id by default' do
      map = MonitorPoint.map_with_key(MonitorPoint.all)
      map.size.should eq(2)
      map[monitor_point_a.id.to_s]['id'].should eq(monitor_point_a.id)
      map[monitor_point_b.id.to_s]['id'].should eq(monitor_point_b.id)
    end

    it 'should be able to map to name as well' do
      map = MonitorPoint.map_with_key(MonitorPoint.all, 'name')
      map.size.should eq(2)
      map['George']['id'].should eq(monitor_point_a.id)
      map['Steve']['id'].should eq(monitor_point_b.id)
    end

  end

end