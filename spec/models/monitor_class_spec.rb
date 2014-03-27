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
      ids = monitor_class.monitor_points_for_all_locations.collect { |mp| mp.id }
      (ids.uniq.size == ids.size).should be_true
    end

    it 'should return all monitor_points if no locations_monitor_classes are defined for the class' do
      monitor_class_b.monitor_points_for_all_locations.size.should eq(4)
    end

    it 'should return all unique ids' do
      ids = monitor_class_b.monitor_points_for_all_locations.collect { |mp| mp.id }
      (ids.uniq.size == ids.size).should be_true
    end

  end

  describe 'monitor_point_ordering' do

    before(:each) do
      FactoryGirl.create(:monitor_point, :name => 'Methane')
      FactoryGirl.create(:monitor_point, :name => 'Oxygen')
    end

    it 'should include Asset, Date Time by default' do
      monitor_class.monitor_point_ordering.should eq('Asset, Date Time')
    end

    it 'should return the exact monitor point ordering if it includes Asset and Date Time' do
      monitor_class.monitor_point_ordering = 'Methane, Asset, Oxygen, Date Time'
      monitor_class.monitor_point_ordering.should eq('Methane, Asset, Oxygen, Date Time')
    end

    it 'should be able to throw Asset into the last index' do
      monitor_class.monitor_point_ordering = 'Methane, Oxygen, Date Time'
      monitor_class.monitor_point_ordering.should eq('Methane, Oxygen, Date Time, Asset')
    end

    it 'should be able to throw Date Time into the last index' do
      monitor_class.monitor_point_ordering = 'Asset, Methane, Oxygen'
      monitor_class.monitor_point_ordering.should eq('Asset, Methane, Oxygen, Date Time')
    end

    it 'should be able to throw Asset and Date TIme into the last index' do
      monitor_class.monitor_point_ordering = 'Methane, Oxygen'
      monitor_class.monitor_point_ordering.should eq('Methane, Oxygen, Asset, Date Time')
    end

  end

  describe 'grouped_monitor_point_ordering' do

    it 'should work fine with just Asset and Date Time' do
      FactoryGirl.create(:monitor_class).
          grouped_monitor_point_ordering.should eq({
                                                       'Asset' => 0,
                                                       'Date Time' => 1,
                                                   })
    end

    it 'should play nice with other monitor points as well' do
      FactoryGirl.create(:monitor_point, :name => 'Methane')
      FactoryGirl.create(:monitor_point, :name => 'Oxygen')
      FactoryGirl.create(:monitor_class, :monitor_point_ordering => 'Methane, Date Time, Oxygen, Asset').
          grouped_monitor_point_ordering.should eq({
                                                       'Methane' => 0,
                                                       'Date Time' => 1,
                                                       'Oxygen' => 2,
                                                       'Asset' => 3
                                                   })
    end

  end

end