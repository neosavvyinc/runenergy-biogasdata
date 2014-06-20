require 'spec_helper'

describe LocationsMonitorClass do

  let :location do
    FactoryGirl.create(:location, :site_name => 'Tom Landfill')
  end

  let :another_location do
    FactoryGirl.create(:location, :site_name => 'George Landfill')
  end

  let :monitor_class do
    FactoryGirl.create(:monitor_class, :name => 'Shorty')
  end

  let :locations_monitor_class do
    FactoryGirl.create(:locations_monitor_class,
                       :location => location,
                       :monitor_class => monitor_class,
                       :column_cache => {:name => 'George'}.to_json,
                       :deleted_column_cache => {:age => 17}.to_json
    )
  end

  before(:each) do
    locations_monitor_class.should_not be_nil
  end

  describe 'self.lazy_load' do

    it 'should be able to create a new one' do
      lmc = LocationsMonitorClass.lazy_load(another_location.id, monitor_class.id)
      lmc.id.should_not be_nil
      lmc.id.should_not eq(locations_monitor_class.id)
    end

    it 'should be able to grab existing' do
      lmc = LocationsMonitorClass.lazy_load(location.id, monitor_class.id)
      lmc.id.should eq(locations_monitor_class.id)
    end

  end

  describe 'self.create_caches' do
    it 'should be able to work with an existing LocationsMonitorClass' do
      lmc = LocationsMonitorClass.create_caches(location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'huey', nil)
      lmc.id.should eq(locations_monitor_class.id)
      lmc.column_cache.should eq({:name => 'Stevie'}.to_json)
      lmc.deleted_column_cache.should eq({:hand => true}.to_json)
      lmc.asset_column_name.should eq('huey')
    end

    it 'should be able to create a new LocationsMonitorClass' do
      lmc = LocationsMonitorClass.create_caches(another_location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'steve', nil)
      lmc.column_cache.should eq({:name => 'Stevie'}.to_json)
      lmc.deleted_column_cache.should eq({:hand => true}.to_json)
      lmc.asset_column_name.should eq('steve')
    end

    it 'should be able to add the date_column_name' do
      lmc = LocationsMonitorClass.create_caches(another_location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'steve', 'This is Date Time')
      lmc.date_column_name.should eq('This is Date Time')
    end

    it 'should be able to add the date_format' do
      lmc = LocationsMonitorClass.create_caches(another_location.id, monitor_class.id, {:name => 'Stevie'}, {:hand => true}, 'steve', 'This is Date Time', '%d-%b-%y')
      lmc.date_format.should eq('%d-%b-%y')
    end
  end

  describe 'display_name' do
    it 'should return the location and then pluralized monitor class name' do
      locations_monitor_class.display_name.should eq('Tom Landfill - Shorties')
    end
  end

  describe 'calculation_names' do

    it 'should return an empty array if there are no custom monitor calculations' do
      FactoryGirl.create(:deluxe_locations_monitor_class).calculation_names.should eq([])
    end

    it 'should return an array of the names if there are custom monitor calculations' do
      lmc = FactoryGirl.create(:deluxe_locations_monitor_class)
      lmc.custom_monitor_calculations << FactoryGirl.create(:custom_monitor_calculation, :name => 'George')
      lmc.custom_monitor_calculations << FactoryGirl.create(:custom_monitor_calculation, :name => 'Harry')
      lmc.calculation_names.should eq(['George', 'Harry'])
    end

  end

  describe 'notifications_for' do
    exception_notification = nil, reading =nil, oxygen = nil, carbon = nil
    before(:each) do
      oxygen = FactoryGirl.create(:monitor_point, :name => 'oxygen')
      carbon = FactoryGirl.create(:monitor_point, :name => 'carbon')
      reading = FactoryGirl.create(:reading, :data => {'name' => 'Steve', 'oxygen' => '20', 'carbon' => 650.67}, :location => locations_monitor_class.location)
      exception_notification = FactoryGirl.create(:exception_notification, :locations_monitor_class => locations_monitor_class)
    end

    it 'should raise an error if the readings location does not match its location' do
      expect {
        locations_monitor_class.notifications_for(FactoryGirl.create(:reading, :location => another_location))
      }.to raise_error
    end

    it 'should pass over cases where a monitor_point is not found' do
      expect(exception_notification).not_to receive(:lower_limit_warning)
      expect(exception_notification).not_to receive(:upper_limit_warning)
      locations_monitor_class.notifications_for(reading)
    end

    pending 'not sure what is going on with these' do
      it 'should call the exception_notification.lower_limit_warning method when a lower limit exception is found' do
        expect(exception_notification).to receive(:lower_limit_warning)
        expect(exception_notification).not_to receive(:upper_limit_warning)
        FactoryGirl.create(:deluxe_monitor_limit, :lower_limit => 30.6, :monitor_point => oxygen, :location => locations_monitor_class.location)
        locations_monitor_class.notifications_for(reading)
      end

      it 'should call the exception_notification.upper_limit_warning method when an upper limit exception is found' do
        expect(exception_notification).not_to receive(:lower_limit_warning)
        expect(exception_notification).to receive(:upper_limit_warning)
        FactoryGirl.create(:deluxe_monitor_limit, :upper_limit => 649, :monitor_point => carbon, :location => locations_monitor_class.location)
        locations_monitor_class.notifications_for(reading)
      end
    end
  end

  describe 'notifications_for_batch' do
    readings = nil

    before(:each) do
      readings = [
          FactoryGirl.create(:reading),
          FactoryGirl.create(:reading),
          FactoryGirl.create(:reading),
          FactoryGirl.create(:reading)
      ]
    end


    it 'should raise an error if passed an invalid type for the warning' do
      expect {
        locations_monitor_class.notifications_for_batch(nil, nil, 'wrong')
      }.to raise_error
    end

    it 'should call notifications_for with the first reading if the reading collection has one element' do
      expect(locations_monitor_class).to receive(:notifications_for)
      locations_monitor_class.notifications_for_batch([readings[0]], [], nil, LocationsMonitorClass::UPPER_LIMIT_WARNING)
    end

  end

  describe 'as_json' do
    it 'should parse out json for the column_cache' do
      locations_monitor_class.as_json['column_cache'].should eq({'name' => 'George'})
    end

    it 'should parse out json for the deleted_column_cache' do
      locations_monitor_class.as_json['deleted_column_cache'].should eq({'age' => 17})
    end
  end

end