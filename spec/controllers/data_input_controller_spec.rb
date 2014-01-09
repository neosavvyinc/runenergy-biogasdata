require 'spec_helper'
require 'json'

describe DataInputController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :customer do
    FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
  end

  let :asset_a do
    FactoryGirl.create(:asset)
  end

  let :asset_b do
    FactoryGirl.create(:asset)
  end

  let :readings_a do
    [
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :asset => asset_a, :monitor_class => asset_a.monitor_class)
    ]
  end

  let :readings_b do
    [
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_class),
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_class),
        FactoryGirl.create(:reading, :asset => asset_b, :monitor_class => asset_b.monitor_class)
    ]
  end

  before(:each) do
    customer.should_not be_nil
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
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_class.id, :asset_id => 'null'
      response.status.should eq(400)
    end

    it 'should return a max of 15 readings for the monitor_class and asset specified' do
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_class.id, :asset_id => asset_a.id
      parsed_response = JSON.parse response.body
      parsed_response.size.should eq(4)
    end

    it 'should return no readings when teh asset and monitor class dont both match' do
      xhr :get, 'readings', :monitor_class_id => asset_b.monitor_class.id, :asset_id => asset_a.id
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

      it 'should define @filter_types' do
        var = controller.instance_variable_get(:@filter_types)
        var.should_not be_nil
        var.size.should be > 0
      end
    end

    describe 'POST' do

      it 'should return a 400 when the request is missing the asset_id' do
        xhr :post, :create, :monitor_class_id => 24, :field_log => {:name => 'Steve'}, :reading => {:methan => 32}
        response.status.should eq(400)
      end

      it 'should return a 400 when the request is missing a monitor_class_id' do
        xhr :post, :create, :asset_id => 24, :field_log => {:name => 'Steve'}, :reading => {:methan => 32}
        response.status.should eq(400)
      end

      it 'should return a 400 when the request is missing a reading' do
        xhr :post, :create, :asset_id => 22, :monitor_class_id => 24, :field_log => {:name => 'Steve'}
        response.status.should eq(400)
      end

      it 'should return a 400 when the request is missing a field_log' do
        xhr :post, :create, :asset_id => 22, :monitor_class_id => 24, :reading => {:methan => 32}
        response.status.should eq(400)
      end

      it 'should create and return a field_log passed in' do
        FieldLog.all.size.should eq(0)
        xhr :post, :create, :asset_id => asset_b.id,
            :monitor_class_id => asset_b.monitor_class.id,
            :field_log => {:name => 'Steve'},
            :reading => {:methane => 32},
            :date => '2013-09-10'
        parsed_response = JSON.parse response.body
        parsed_response['field_log']['id'].should be > 0
        parsed_response['field_log']['data']['name'].should eq('Steve')
        FieldLog.all.size.should eq(1)
      end

      it 'should create and return the reading passed in' do
        Reading.all.size.should eq(7)
        xhr :post, :create, :asset_id => asset_b.id,
            :monitor_class_id => asset_b.monitor_class.id,
            :field_log => {:name => 'Steve'},
            :reading => {:methane => 65},
            :date => '2010-11-20'
        parsed_response = JSON.parse response.body
        parsed_response['reading']['id'].should be > 0
        parsed_response['reading']['data']['methane'].should eq('65')
        Reading.all.size.should eq(8)
      end

    end
  end

  describe 'import' do
    describe 'GET' do
      before(:each) do
        get :import
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

      it 'should define @filter_types' do
        var = controller.instance_variable_get(:@filter_types)
        var.should_not be_nil
        var.size.should be > 0
      end
    end
    
    describe 'POST' do

      it 'should set the error if the :column_definition_row param is blank' do
        post :import, :first_data_row => 6
        controller.instance_variable_get(:@error).should_not be_nil
      end

      it 'should set the error if the :first_data_row is blank' do
        post :import, :column_definition_row => 89
        controller.instance_variable_get(:@error).should_not be_nil
      end
      
    end
  end

end

