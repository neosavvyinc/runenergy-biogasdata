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

  let :asset_b do
    FactoryGirl.create(:asset)
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class)
  end

  let :readings do
    [
        FactoryGirl.create(:reading, :asset => asset, :location => location, :monitor_class => monitor_class, :taken_at => DateTime.new(2010)),
        FactoryGirl.create(:reading, :asset => asset, :location => location, :monitor_class => monitor_class, :taken_at => DateTime.new(2012)),
        FactoryGirl.create(:reading, :asset => asset_b, :location => location, :monitor_class => monitor_class, :taken_at => DateTime.new(2014))
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
      xhr :get, 'readings', :site_id => 'null', :monitor_class_id => monitor_class.id
      response.status.should eq(400)
    end

    it 'should return a 400 error if not passed a monitor_class_id in the request' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => 'null'
      response.status.should eq(400)
    end

    it 'should return all the readings for an asset_id if passed in' do
      xhr :get, 'readings', :asset_id => asset_b.id, :site_id => location.id, :monitor_class_id => monitor_class.id
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].should_not be_nil
      parsed_response['readings'].size.should eq(1)
    end

    it 'should return all readings for the site if a valid site_id is passed in' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].should_not be_nil
      parsed_response['readings'].size.should eq(3)
    end

    it 'should support time since epoch start date for the readings' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id, :start_date_time => DateTime.new(2012).to_i
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].size.should eq(2)
    end

    it 'should support time since epoch end date for the readings' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id, :end_date_time => DateTime.new(2011).to_i
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].size.should eq(1)
    end

    it 'should support a range between start and end for the date range' do
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id, :start_date_time => DateTime.new(2013).to_i, :end_date_time => DateTime.new(2015).to_i
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].size.should eq(1)
    end

    it 'should be able to return readings for a specific asset' do
      reading = FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset))
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id, :asset_id => reading.asset.id
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].should_not be_nil
      parsed_response['readings'].size.should eq(1)
      parsed_response['readings'][0]['id'].should eq(reading.id)
    end

    it 'should be able to return readings for a specific section' do
      section = FactoryGirl.create(:section)
      reading = FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset, :section => section))
      reading_b = FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset, :section => section))
      xhr :get, 'readings', :site_id => location.id, :monitor_class_id => monitor_class.id, :section_id => section.id
      parsed_response = JSON.parse(response.body)
      parsed_response['readings'].should_not be_nil
      parsed_response['readings'].size.should eq(2)
      parsed_response['readings'][0]['id'].should eq(reading.id)
      parsed_response['readings'][1]['id'].should eq(reading_b.id)
    end

  end

  describe 'update' do
    my_reading = nil

    before(:each) do
      my_reading = readings[1]
    end

    it 'should return an error with status 400 if no id is passed in' do
      xhr :post, 'update', :id => 'null'
      response.status.should eq(400)
    end

    it 'should update the date with params other than Date Time and id' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/02/14, 16:07:00', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15
      my_reading = Reading.find(my_reading.id)
      JSON.parse(my_reading.data).should eq({'Methane' => '45', 'Oxygen' => '89', 'Water Color' => '15'})
    end

    it 'should return the new reading in the response' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/02/14, 16:07:00', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15
      JSON.parse(response.body)['id'].should eq(my_reading.id)
    end

    it 'should apply an asset with the unique identifier to the reading returned' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/02/14, 16:07:00', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15, 'Asset' => '60IO'
      JSON.parse(response.body)['asset']['id'].should eq(Asset.find_by_unique_identifier('60IO').id)
    end

    it 'should apply the Date Time key to the taken_at date' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/11/14, 16:07:19', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15, 'Asset' => '60IO'
      Reading.find(JSON.parse(response.body)['id']).taken_at.should eq(DateTime.strptime('06/11/14, 16:07:19', '%d/%m/%y, %H:%M:%S').utc)
    end

    it 'should not add Asset to the data hash' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/11/14, 16:07:19', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15, 'Asset' => '60IO'
      JSON.parse(response.body)['data']['Asset'].should be_nil
    end

    it 'should not add Date Time to the data hash' do
      xhr :post, 'update', :id => my_reading.id, 'Date Time' => '06/11/14, 16:07:19', 'Methane' => 45, 'Oxygen' => 89, 'Water Color' => 15, 'Asset' => '60IO'
      JSON.parse(response.body)['data']['Date Time'].should be_nil
    end
  end

end