require 'spec_helper'

describe MonitorClass do

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :monitor_class_b do
    FactoryGirl.create(:monitor_class)
  end

  let :monitor_point do
    FactoryGirl.create(:monitor_point)
  end

  let :locations_monitor_class_a do
    lmc = FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class, :location => FactoryGirl.create(:location))
    lmc.monitor_points << FactoryGirl.create(:monitor_point)
    lmc.monitor_points << FactoryGirl.create(:monitor_point)
    lmc
  end

  let :locations_monitor_class_b do
    lmc = FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class, :location => FactoryGirl.create(:location))
    lmc.monitor_points << FactoryGirl.create(:monitor_point)
    lmc
  end

  describe 'monitor_points_for_all_locations' do

    before(:each) do
      locations_monitor_class_a.should_not be_nil
      locations_monitor_class_b.should_not be_nil
      monitor_point.should_not be_nil
    end

    it 'should return a collection of monitor points, with length 3' do
      monitor_class.monitor_points_for_all_locations.size.should eq(3)
    end

    it 'should return a collection of monitor_points with unique ids' do
      ids = monitor_class.monitor_points_for_all_locations.collect {|mp| mp.id}
      (ids.uniq.size == ids.size).should be_true
    end

    it 'should return all monitor_points if no locations_monitor_classes are defined for the class' do
      monitor_class_b.monitor_points_for_all_locations.size.should eq(4)
    end

    it 'should return all unique ids' do
      ids = monitor_class_b.monitor_points_for_all_locations.collect {|mp| mp.id}
      (ids.uniq.size == ids.size).should be_true
    end

  end

end