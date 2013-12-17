require 'spec_helper'
require 'json'

describe DataInputController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :asset_a do
    FactoryGirl.create(:asset)
  end

  let :asset_b do
    FactoryGirl.create(:asset)
  end

  let :readings_a do
    [
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_classes[0]),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_classes[0]),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_classes[0]),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_classes[0])
    ]
  end

  let :readings_b do
    [
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_classes[0]),
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_classes[0]),
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_classes[0])
    ]
  end

  before(:each) do
    readings_a.should_not be_nil
    readings_b.should_not be_nil

    #For later tests that returns all locations
    FactoryGirl.create(:location)
    FactoryGirl.create(:section)

    sign_in overseer
  end

  describe 'readings' do

    it 'should return a 400 error when there is no monitor_class_id specified' do
      xhr :get, 'readings', :monitor_class_id => 'null', :asset_id => asset_b.id
      response.status.should eq(400)
    end

    it 'should return a 400 error when there is no asset_id specified' do
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_classes.first.id, :asset_id => 'null'
      response.status.should eq(400)
    end

    it 'should return a max of 15 readings for the monitor_class and asset specified' do
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_classes.first.id, :asset_id => asset_a.id
      parsed_response = JSON.parse response.body
      parsed_response.size.should eq(4)
    end

    it 'should return no readings when teh asset and monitor class dont both match' do
      xhr :get, 'readings', :monitor_class_id => asset_b.monitor_classes.first.id, :asset_id => asset_a.id
      parsed_response = JSON.parse response.body
      parsed_response.size.should eq(0)
    end

  end

  describe 'create' do
    describe 'GET' do
      before(:each) do
        get :create
      end

      it 'should define @landfill_operators' do
        var = controller.instance_variable_get(:@landfill_operators)
        var.should_not be_nil
        var.size.should be > 0
      end

      it 'should define @sites' do
        var = controller.instance_variable_get(:@sites)
        var.should_not be_nil
        var.size.should be > 0
      end

      it 'should define @sections' do
        var = controller.instance_variable_get(:@sections)
        var.should_not be_nil
        var.size.should be > 0
      end

      it 'should define @assets' do
        var = controller.instance_variable_get(:@assets)
        var.should_not be_nil
        var.size.should be > 0
      end

      it 'should define @monitor_classes' do
        var = controller.instance_variable_get(:@monitor_classes)
        var.should_not be_nil
        var.size.should be > 0
      end
    end

    describe 'POST' do

      it 'should return a 400 when the request is missing the asset_id' do

      end

      it 'should return a 400 when the request is missing a monitor_class_id' do

      end

      it 'should return a 400 when the request is missing a reading' do

      end

      it 'should return a 400 when the request is missing a field_log' do

      end

    end
  end

  describe 'import' do

  end

end

