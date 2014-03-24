require 'spec_helper'

describe VisualizationsController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  before(:each) do
    sign_in overseer
  end

  describe 'monitor_point_progress' do

    let :monitor_point do
      FactoryGirl.create(:monitor_point, :name => 'Methane')
    end

    let :location do
      FactoryGirl.create(:location)
    end

    let :monitor_class do
      FactoryGirl.create(:monitor_class)
    end

    readings = nil,
        two_months_ago = (Date.today.beginning_of_day - 2.months),
        month_ago = (Date.today.beginning_of_day - 1.months),
        today = Date.today.beginning_of_day

    before(:each) do
      FactoryGirl.create(:reading, :data => {'Methane' =>  57}, :taken_at => two_months_ago, :location => location, :monitor_class => monitor_class)
      FactoryGirl.create(:reading, :data => {'Methane' =>  59}, :taken_at => month_ago, :location => location, :monitor_class => monitor_class)
      FactoryGirl.create(:reading, :data => {'Methane' =>  36}, :taken_at => today, :location => location, :monitor_class => monitor_class)

      #Non Matches
      FactoryGirl.create(:reading, :data => {'Methane' =>  390}, :taken_at => today, :location => location)
      FactoryGirl.create(:reading, :data => {'Methane' =>  10}, :taken_at => today, :monitor_class => monitor_class)
    end

    it 'should set the monitor_point instance variable based on the id passed in' do
      get :monitor_point_progress, :monitor_point_id => monitor_point.id
      controller.instance_variable_get(:@monitor_point).should eq(monitor_point)
    end

    it 'should set the readings instance variable' do
      get :monitor_point_progress, :monitor_point_id => monitor_point.id, :site => location.id, :monitor_class => monitor_class.id
      controller.instance_variable_get(:@readings).size.should eq(3)
    end

    it 'should return arrays with two indexes, the first should have the value organized by date' do
      get :monitor_point_progress, :monitor_point_id => monitor_point.id, :site => location.id, :monitor_class => monitor_class.id
      readings = controller.instance_variable_get(:@readings)
      readings[0][1].should eq(57)
      readings[1][1].should eq(59)
      readings[2][1].should eq(36)
    end

    it 'should have a formatted date in the 0 index' do
      get :monitor_point_progress, :monitor_point_id => monitor_point.id, :site => location.id, :monitor_class => monitor_class.id
      readings = controller.instance_variable_get(:@readings)
      readings[0][0].should eq(two_months_ago.strftime('%Y%m%d'))
      readings[1][0].should eq(month_ago.strftime('%Y%m%d'))
      readings[2][0].should eq(today.strftime('%Y%m%d'))
    end
  end

  describe 'heat_map' do

    let :monitor_point do
      FactoryGirl.create(:monitor_point)
    end

    let :monitor_class do
      FactoryGirl.create(:monitor_class)
    end

    let :location do
      FactoryGirl.create(:location)
    end

    it 'should return a 400 error if no site is passed in' do
      get :heat_map, :monitor_class => monitor_class.id, :monitor_point_id => monitor_point.id
      response.status.should eq(400)
    end

    it 'should declare a 400 error if no monitor_class is passed in' do
      get :heat_map, :site => location.id, :monitor_point_id => monitor_point.id
      response.status.should eq(400)
    end

    it 'should set a @locations_monitor_class variable on the controller' do
      get :heat_map, :site => location.id, :monitor_class => monitor_class.id, :monitor_point_id => monitor_point.id
      controller.instance_variable_get(:@locations_monitor_class).should eq(LocationsMonitorClass.where(:location_id => location.id, :monitor_class_id => monitor_class.id).first)
    end
    
    it 'should set an @asset_map instance variable on the controller' do
      get :heat_map, :site => location.id, :monitor_class => monitor_class.id, :monitor_point_id => monitor_point.id
      controller.instance_variable_get(:@asset_map).should eq([])
    end

    it 'should set a @reading_map instance variable on the controller' do
      get :heat_map, :site => location.id, :monitor_class => monitor_class.id, :monitor_point_id => monitor_point.id
      controller.instance_variable_get(:@reading_map).should eq([])
    end
    
  end

end