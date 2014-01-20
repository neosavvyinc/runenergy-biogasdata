require 'spec_helper'
require 'json'

describe DataAnalysisController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :location do
    FactoryGirl.create(:location)
  end

  let :section do
    FactoryGirl.create(:section, :location => location)
  end

  let :asset do
    FactoryGirl.create(:asset, :section => section)
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :readings do
    [
        FactoryGirl.create(:reading, :asset => asset, :location => location, :monitor_class => monitor_class),
        FactoryGirl.create(:reading, :asset => asset, :location => location, :monitor_class => monitor_class),
        FactoryGirl.create(:reading, :asset => asset, :location => location, :monitor_class => monitor_class)
    ]
  end

  let :monitor_point do
    mp = FactoryGirl.create(:monitor_point, :name => 'Charlie')
    mp.assets << asset
    mp
  end

  let :monitor_point_b do
    mp = FactoryGirl.create(:monitor_point, :name => 'George')
    mp.assets << asset
    mp
  end

  before(:each) do
    readings.should_not be_nil
    monitor_point.should_not be_nil
    monitor_point_b.should_not be_nil
    sign_in overseer
  end

  describe 'index' do
    before(:each) do
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
      FactoryGirl.create(:location)
      FactoryGirl.create(:section)
      FactoryGirl.create(:section)
      FactoryGirl.create(:section)
      FactoryGirl.create(:asset)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      FactoryGirl.create(:monitor_class)
      get :index
    end

    it 'should set the @landfill_operators variable to all the customer type users' do
      controller.instance_variable_get(:@landfill_operators).size.should eq(2)
    end

    it 'should set the @sites to Location.all' do
      controller.instance_variable_get(:@sites).size.should be > 0
    end

    it 'should set the @sections to Section.all' do
      controller.instance_variable_get(:@sections).size.should be > 0
    end

    it 'should set the @assets to Asset.all' do
      controller.instance_variable_get(:@assets).size.should be > 0
    end

    it 'should set the @monitor_classes to MonitorClass.all' do
      controller.instance_variable_get(:@monitor_classes).size.should be > 0
    end

    it 'should set the @filter_types to DataAnalysisFilter mapping' do
      controller.instance_variable_get(:@filter_types).size.should be > 0
    end
  end

  describe 'readings' do

    it 'should return a 400 error if not passed a site_id in the request' do
      xhr :get, 'readings', :site_id => 'null'
      response.status.should eq(400)
    end

    it 'should return all readings for the site if a valid site_id is passed in' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].should_not be_nil
      parsed_response['readings'].size.should eq(3)
    end

  end

  describe 'monitor_points' do
    it 'should return a 400 error if not passed an asset_id in the request' do
      xhr :get, 'monitor_points', :asset_id => 'null'
      response.status.should eq(400)
    end

    it 'should return all the monitor points for the asset if a valid asset_id is passed in' do
      xhr :get, 'monitor_points', :asset_id => asset.id
      parsed_response = JSON.parse(response.body)
      parsed_response['monitor_points'].should_not be_nil
      parsed_response['monitor_points'].size.should eq(2)
    end
  end
end