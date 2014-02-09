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

  let :location_a do
    FactoryGirl.create(:location)
  end

  let :location_b do
    FactoryGirl.create(:location)
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :readings_a do
    [
        FactoryGirl.create(:reading, :location => location_a, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :location => location_a, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :location => location_a, :asset => asset_a, :monitor_class => asset_a.monitor_class),
        FactoryGirl.create(:reading, :location => location_a, :asset => asset_a, :monitor_class => asset_a.monitor_class)
    ]
  end

  let :readings_b do
    [
        FactoryGirl.create(:reading, :location => location_b, :asset => asset_b, :monitor_class => asset_b.monitor_class),
        FactoryGirl.create(:reading, :location => location_b, :asset => asset_b, :monitor_class => asset_b.monitor_class),
        FactoryGirl.create(:reading, :location => location_b, :asset => asset_b, :monitor_class => asset_b.monitor_class)
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
      xhr :get, 'readings', :monitor_class_id => 'null', :site_id => location_a.id
      response.status.should eq(400)
    end

    it 'should return a 400 error when there is no asset_id specified' do
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_class.id, :site_id => 'null'
      response.status.should eq(400)
    end

    it 'should return a max of 15 readings for the monitor_class and asset specified' do
      xhr :get, 'readings', :monitor_class_id => asset_a.monitor_class.id, :site_id => location_a.id
      parsed_response = JSON.parse response.body
      parsed_response.size.should eq(4)
    end

    it 'should return no readings when the asset and monitor class dont both match' do
      xhr :get, 'readings', :monitor_class_id => asset_b.monitor_class.id, :site_id => location_a.id
      parsed_response = JSON.parse response.body
      parsed_response.size.should eq(0)
    end

  end

  describe 'locations_monitor_class' do

    let :locations_monitor_class do
      FactoryGirl.create(:deluxe_locations_monitor_class)
    end

    it 'should return a status 400 if there is not :site_id' do
      xhr :get, 'locations_monitor_class', :site_id => 'null', :monitor_class_id => 17
      response.status.should eq(400)
    end

    it 'should return a status 400 if there is no :monitor_class_id' do
      xhr :get, 'locations_monitor_class', :site_id => 18, :monitor_class_id => ''
      response.status.should eq(400)
    end

    describe 'GET' do
      it 'should return the locations monitor class as json with any get request that is valid' do
        xhr :get, 'locations_monitor_class', :site_id => locations_monitor_class.location.id, :monitor_class_id => locations_monitor_class.monitor_class.id
        parsed_response = JSON.parse(response.body)
        parsed_response['id'].should eq(locations_monitor_class.id)
      end

      it 'should return nil for invalid site and monitor class pairings' do
        xhr :get, 'locations_monitor_class', :site_id => locations_monitor_class.location.id + 1, :monitor_class_id => locations_monitor_class.monitor_class.id
        response.body.should eq('null')
      end
    end

    describe 'POST' do
      it 'should lazy load the locations monitor class from the site_id and monitor_class_id' do
        xhr :post, 'locations_monitor_class', :site_id => locations_monitor_class.location.id,
            :monitor_class_id => locations_monitor_class.monitor_class.id,
            :monitor_points => [{:name => 'Uranium'}]
        LocationsMonitorClass.last.id.should eq(locations_monitor_class.id)
      end

      it 'should respond with the last loaded locations monitor class' do
        xhr :post, 'locations_monitor_class', :site_id => locations_monitor_class.location.id,
            :monitor_class_id => locations_monitor_class.monitor_class.id,
            :monitor_points => [{:name => 'Uranium'}]
        JSON.parse(response.body)['id'].should eq(locations_monitor_class.id)
      end

      it 'should automagically add the RAIN SINCE PREVIOUS READING field log point to the locations monitor class' do
        xhr :post, 'locations_monitor_class', :site_id => locations_monitor_class.location.id,
            :monitor_class_id => locations_monitor_class.monitor_class.id,
            :monitor_points => [{:name => 'Uranium'}]
        LocationsMonitorClass.last.field_log_points.size.should eq(1)
        LocationsMonitorClass.last.field_log_points.first.id.should eq(FieldLogPoint.RAIN_SINCE_PREVIOUS_READING.id)
      end

      it 'should apply monitor_points lazy loaded to the locations monitor class' do
        xhr :post, 'locations_monitor_class', :site_id => locations_monitor_class.location.id,
            :monitor_class_id => locations_monitor_class.monitor_class.id,
            :monitor_points => [{:name => 'Uranium'}]
        locations_monitor_class.monitor_points.size.should eq(1)
        locations_monitor_class.monitor_points.first.name.should eq('Uranium')
      end
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

      it 'should not define @sections' do
        var = controller.instance_variable_get(:@sections)
        var.should be_nil
      end

      it 'should not define @assets' do
        var = controller.instance_variable_get(:@assets)
        var.should be_nil
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
        xhr :post, :create, :asset_unique_identifier => asset_b.id,
            :monitor_class_id => asset_b.monitor_class.id,
            :site_id => location_b.id,
            :field_log => {:name => 'Steve'},
            :reading => {:methane => 32},
            :date_time => DateTime.new(2010).to_i
        parsed_response = JSON.parse response.body
        parsed_response['field_log']['id'].should be > 0
        parsed_response['field_log']['data']['name'].should eq('Steve')
        FieldLog.all.size.should eq(1)
      end

      it 'should create and return the reading passed in' do
        Reading.all.size.should eq(7)
        xhr :post, :create, :asset_unique_identifier => asset_b.id,
            :monitor_class_id => asset_b.monitor_class.id,
            :site_id => location_b.id,
            :field_log => {:name => 'Steve'},
            :reading => {:methane => 65},
            :date_time => DateTime.new(2013).to_i
        parsed_response = JSON.parse response.body
        parsed_response['reading']['id'].should be > 0
        parsed_response['reading']['data']['methane'].should eq('65')
        Reading.all.size.should eq(8)
      end

    end
  end

  describe 'create_monitor_point' do
    it 'should return an error response of status 400 if there is no site_id' do
      xhr :post, :create_monitor_point, :monitor_class_id => monitor_class.id, :name => 'Spif', :unit => 'Hz.'
    end

    it 'should return an error response of status 400 if there is no monitor_class_id' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :name => 'Spif', :unit => 'Hz.'
    end

    it 'should return an error response of status 400 if there is no name' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :unit => 'Hz.'
      response.status.should eq(400)
    end

    it 'should return an error respoinse of status 400 if there is no unit' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :name => 'Water Pressure'
      response.status.should eq(400)
    end

    it 'should create a new monitor point from the params' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :name => 'Water Pressure', :unit => 'Hz.'
      JSON.parse(response.body)['id'].should eq(MonitorPoint.last.id)
    end

    it 'should apply the name to the new monitor point' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :name => 'Volume', :unit => 'Dcb.'
      JSON.parse(response.body)['name'].should eq('Volume')
    end

    it 'should apply the name to the new monitor point' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :name => 'Volume', :unit => 'mli.'
      JSON.parse(response.body)['unit'].should eq('mli.')
    end

    it 'should add the monitor point to the LocationsMonitClass for the pair' do
      xhr :post, :create_monitor_point, :site_id => location_a.id, :monitor_class_id => monitor_class.id, :name => 'Volume', :unit => 'mli.'
      monitor_points = LocationsMonitorClass.where(:location_id => location_a.id, :monitor_class_id => monitor_class.id).first.monitor_points
      monitor_points.size.should eq(1)
      monitor_points.first.id.should eq(JSON.parse(response.body)['id'])
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

  describe 'complete_import' do
    let :location do
      FactoryGirl.create(:location)
    end

    let :monitor_class do
      FactoryGirl.create(:monitor_class)
    end

    it 'should return a status 400 error if readings is nil' do
      xhr :post, :complete_import, :reading_mods => {}, :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
      response.status.should eq(400)
    end

    it 'should return a status 400 error if readings is empty' do
      xhr :post, :complete_import, :readings => [], :reading_mods => {}, :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
      response.status.should eq(400)
    end

    it 'should return a status 400 error if reading_mods is empty' do
      xhr :post, :complete_import, :readings => readings_b, :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
      response.status.should eq(400)
    end

    it 'should return a status 400 error if site_id is blank' do
      xhr :post, :complete_import, :readings => readings_b, :reading_mods => {}, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
      response.status.should eq(400)
    end

    it 'should return a status 400 error if monitor_class_id is blank' do
      xhr :post, :complete_import, :readings => readings_b, :reading_mods => {}, :site_id => location.id, :asset_column_name => 'Well ID'
      response.status.should eq(400)
    end

    it 'should return a status 400 error if asset_column_name is blank' do
      xhr :post, :complete_import, :readings => readings_b, :reading_mods => {}, :site_id => location.id, :monitor_class_id => monitor_class.id
      response.status.should eq(400)
    end

    describe 'valid' do

      it 'should call LocationsMonitorClass.create_caches once' do
        #Stub out method
        expect(Reading).to receive(:process_edited_collection).once.and_return(readings_a)
        expect(LocationsMonitorClass).to receive(:create_caches).once

        xhr :post, :complete_import, :readings => readings_a, :reading_mods => {},
            :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
        JSON.parse(response.body)['readings'].should eq(JSON.parse(readings_a.to_json))
      end

      it 'should call Reading.process_edited_collection with the parameters' do
        #Stub out method
        expect(Reading).to receive(:process_edited_collection).once.and_return(readings_a)

        xhr :post, :complete_import, :readings => readings_a, :reading_mods => {},
            :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_column_name => 'Well ID'
        JSON.parse(response.body)['readings'].should eq(JSON.parse(readings_a.to_json))
      end
      
    end
  end

  describe 'approve_limit_breaking_set' do
    readings = nil, location = nil, monitor_class = nil, locations_monitor_class = nil

    before(:each) do
      location = FactoryGirl.create(:location)
      monitor_class = FactoryGirl.create(:monitor_class)
      locations_monitor_class = FactoryGirl.create(:locations_monitor_class,
                                                   :location => location,
                                                   :monitor_class => monitor_class)
      readings = [
          FactoryGirl.create(:reading, :location => location, :monitor_class => monitor_class).as_json,
          FactoryGirl.create(:reading, :location => location, :monitor_class => monitor_class).as_json,
          FactoryGirl.create(:reading, :location => location, :monitor_class => monitor_class).as_json,
          FactoryGirl.create(:reading, :location => location, :monitor_class => monitor_class).as_json,
          FactoryGirl.create(:reading, :location => location, :monitor_class => monitor_class).as_json
      ]
    end

    it 'should send back an error if not passed a readings parameter' do
      xhr :post, :approve_limit_breaking_set, :deleted_ids => {}, :type => 'upper_limit'
      response.status.should eq(400)
    end

    it 'should send back an error if not passed a deleted_ids parameter' do
      xhr :post, :approve_limit_breaking_set, :readings => [], :type => 'upper_limit'
      response.status.should eq(400)
    end

    it 'should return all the readings and an empty deleted collection if none are deleted' do
      xhr :post, :approve_limit_breaking_set, :readings => readings, :deleted_ids => {}, :type => 'lower_limit'
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].size.should eq(5)
      parsed_response['deleted'].size.should eq(0)
    end

    it 'should return the deleted readings in a collection when some deleted_ids are passed in' do
      hash = {}
      hash[readings[1]['id']] = true
      hash[readings[3]['id']] = true
      xhr :post, :approve_limit_breaking_set, :readings => readings, :deleted_ids => hash, :type => 'lower_limit'
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].size.should eq(3)
      parsed_response['deleted'].size.should eq(2)
    end

    it 'should physically delete the deleted readings' do
      hash = {}
      hash[readings[1]['id'].to_s] = true
      hash[readings[3]['id'].to_s] = true
      xhr :post, :approve_limit_breaking_set, :readings => readings, :deleted_ids => hash, :type => 'upper_limit'
      Reading.where(:id => readings[1]['id']).first.should be_nil
      Reading.where(:id => readings[3]['id']).first.should be_nil
    end

  end

end

