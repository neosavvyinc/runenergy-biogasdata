require 'spec_helper'

describe Reading do

  describe 'self.process_csv' do

    it 'should raise an error if passed a blank file parameter' do
      expect {
        Reading.process_csv(nil)
      }.to raise_error
    end

  end

  describe 'self.new_from_csv_row' do
    it 'should do nothing if the header is empty' do
      Reading.new_from_csv_row([], [1, 2, 3]).should be_nil
    end

    it 'should return nothing if the row is empty' do
      Reading.new_from_csv_row([4, 5, 6], []).should be_nil
    end

    it 'should create a new reading for the indexes in the header and row' do
      Reading.new_from_csv_row(
          ['name', 'location', 'age'],
          ['Charles', 'South America', 67]
      ).data.should eq({
                           'name' => 'Charles',
                           'location' => 'South America',
                           'age' => 67
                       }.to_json)
    end

    it 'should ignore blank values in the header' do
      Reading.new_from_csv_row(
          ['', 'name', 'location', 'age'],
          [56, 'Charles', 'South America', 67]
      ).data.should eq({
                           'name' => 'Charles',
                           'location' => 'South America',
                           'age' => 67
                       }.to_json)
    end
  end

  describe 'self.process_edited_collection' do

    let :monitor_class do
      FactoryGirl.create(:monitor_class)
    end

    it 'should raise an error if the collection is nil' do
      expect {
        Reading.process_edited_collection(nil, {}, {}, [], 10, 11, 12, DateTime.now)
      }.to raise_error
    end

    it 'should raise an error if the site_id is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], '', 11, 12, DateTime.now)
      }.to raise_error
    end

    it 'should raise an error if the monitor_class_id is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], 10, nil, 12, DateTime.now)
      }.to raise_error
    end

    it 'should raise an error if the asset_column_name is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], 10, 11, '', DateTime.now)
      }.to raise_error
    end

    it 'should return no readings if all rows passed in ared deleted' do
      my_readings = Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [1, 2, 3], 7, 8, 9, DateTime.now)
      my_readings.should eq([])
    end

    it 'should add a row to new readings for each row that is not in a deleted index' do
      #Stub out method
      expect(Reading).to receive(:map_and_validate_columns).twice.and_return({'data_no' => rand(30)})

      #Call
      my_readings = Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [2], 1, monitor_class.id, 3, DateTime.now)
      my_readings.size.should eq(2)
    end
  end

  describe 'self.map_and_validate_columns' do
    let :monitor_point do
      FactoryGirl.create(:monitor_point, :name => 'Sequestration')
    end

    let :monitor_point_b do
      FactoryGirl.create(:monitor_point, :name => 'Charles Bronson')
    end

    it 'should return an empty reading if there is no column to id for the column in the reading' do
      data = Reading.map_and_validate_columns({'Wind Mill' => 50}, {}, {}, {})
      data.should eq({})
    end

    it 'should return an empty reading if the only data element is in the deleted_columnns' do
      data = Reading.map_and_validate_columns({'Wind Mill' => 50}, {'Wind Mill' => 27}, {'Wind Mill' => true}, {})
      data.should eq({})
    end

    it 'should create a new reading with the keys replaced by the monitor points' do
      data = Reading.map_and_validate_columns(
          {'Wind Mill' => 67, 'Georgia Mud' => 'Hello Friends'},
          {'Wind Mill' => {'id' => monitor_point.id}, 'Georgia Mud' => {'id' => monitor_point_b.id}},
          {},
          {}
      )
      data.should eq({'Sequestration' => '67', 'Charles Bronson' => 'Hello Friends'})
    end

    it 'should be able to delete a monitor point' do
      data = Reading.map_and_validate_columns(
          {'Wind Mill' => 67, 'Georgia Mud' => 'Hello Friends'},
          {'Wind Mill' => {'id' => monitor_point.id}, 'Georgia Mud' => {'id' => monitor_point_b.id}},
          {'Wind Mill' => true},
          {}
      )
      data.should eq({'Charles Bronson' => 'Hello Friends'})
    end
  end

  describe 'self.choose_reading_date' do
    data = nil, other_data = nil

    before(:each) do
      data = {'Date Time' => '10-Jun-15'}
      other_data = {'Taken When' => 'August 19, 2001'}
    end

    it 'should return the reading_date value if there is no date_column_name passed in' do
      reading_date = DateTime.now
      Reading.choose_reading_date(data, reading_date, nil, '%d-%b-%y').should eq(reading_date)
    end

    it 'should default to the date format %d-%b-%y unless a date format is passed in' do
      Reading.choose_reading_date(data, DateTime.now, 'Date Time').should eq(DateTime.strptime('10-Jun-15', '%d-%b-%y'))
    end

    it 'should use the date_format provided if it is passed in' do
      Reading.choose_reading_date(other_data, DateTime.now, 'Taken When', '%B %d, %Y').should eq(DateTime.strptime('August 19, 2001', '%B %d, %Y'))
    end

    it 'should return a specific exception if the date does not match the format' do
      expect {
        Reading.choose_reading_date(other_data, DateTime.now, 'Taken When')
      }.to raise_error(Exceptions::InvalidDateFormatException)
    end

    it 'should not blow up if there is nothing at the index' do
      Reading.choose_reading_date(other_data, DateTime.now, 'Taken How').should be_nil
    end
  end

  describe 'self.export_csv' do

    let :asset do
      FactoryGirl.create(:asset, :unique_identifier => '25OR624')
    end

    let :ordered_monitor_class do
      FactoryGirl.create(:monitor_class, :monitor_point_ordering => 'Oxygen, Methane')
    end

    let :reading do
      FactoryGirl.create(:reading, :taken_at => DateTime.new(2013, 3, 17, 6, 17, 48), :data => {'Methane' => 65, 'Oxygen' => 19.5}, :monitor_class => FactoryGirl.create(:monitor_class), :asset => asset)
    end

    let :ordered_reading do
      FactoryGirl.create(:reading, :taken_at => DateTime.new(2013, 7, 17, 6, 17, 48), :data => {'Methane' => 17, 'Oxygen' => 22.1}, :monitor_class => ordered_monitor_class, :asset => asset)
    end

    before(:each) do
      FactoryGirl.create(:monitor_point, :name => 'Methane')
      FactoryGirl.create(:monitor_point, :name => 'Oxygen')
    end

    it 'should return an empty csv if there are no readings by the options provided' do
      Reading.export_csv(:id => -1).should eq('')
    end

    it 'should be able to throw a header on the csv, based on the first reading' do
      Reading.export_csv(:id => FactoryGirl.create(:reading, :monitor_class => FactoryGirl.create(:monitor_class)).id).split(/\r?\n/).first.should eq('Asset,Date Time,index')
    end

    it 'should be able to do an ordered header' do
      Reading.export_csv(:id => ordered_reading.id).split(/\r?\n/).first.should eq('Oxygen,Methane,Asset,Date Time')
    end

    it 'should be able to do the first row' do
      Reading.export_csv(:id => reading.id).split(/\r?\n/)[1].should eq('25OR624,"17/03/2013, 06:17:48",65,19.5')
    end

    it 'should be able to do the ordered first row' do
      Reading.export_csv(:id => ordered_reading.id).split(/\r?\n/)[1].should eq('22.1,17,25OR624,"17/07/2013, 06:17:48"')
    end

  end

  let :reading do
    FactoryGirl.create(
        :reading,
        :data => {
            'name' => 'Georgie',
            'location' => 'NYC',
            'age' => 67
        }.to_json,
        :field_log => FactoryGirl.create(:field_log)
    )
  end

  describe 'taken_at_epoch' do

    it 'should return nil if the time is undefined' do
      FactoryGirl.create(:reading).taken_at_epoch.should be_nil
    end

    it 'should return the epoch time otherwise' do
      FactoryGirl.create(:reading, :taken_at => DateTime.new(2001, 10, 10)).taken_at_epoch.should eq(1002672000.0)
    end

  end

  describe 'previous_readings_for_indices' do

    it 'should return an empty object if indices is nil' do
      FactoryGirl.create(:reading).previous_readings_for_indices(nil).should eq({})
    end

    it 'should return an empty object if the indices is empty' do
      FactoryGirl.create(:reading).previous_readings_for_indices([]).should eq({})
    end

    it 'should call the previous reading method with the absolute value of the integer' do
      reading = FactoryGirl.create(:reading)
      other_reading = FactoryGirl.create(:reading)
      expect(reading).to receive(:previous_reading).once.with(25).and_return(other_reading)
      reading.previous_readings_for_indices(['-25']).should eq({'-25' => JSON.parse(other_reading.data)})
    end

  end

  describe 'previous_reading' do

    it 'should be specific to asset' do
      asset = FactoryGirl.create(:asset)
      FactoryGirl.create(:reading, :taken_at => (DateTime.now - 15.hours), :asset => asset)
      FactoryGirl.create(:reading, :taken_at => (DateTime.now - 45.minutes), :asset => asset)
      reading = FactoryGirl.create(:reading, :taken_at => DateTime.now, :asset => asset)

      new_before_reading = FactoryGirl.create(:reading, :taken_at => (DateTime.now - 15.minutes))
      reading.previous_reading.should_not eq(new_before_reading)
    end

    it 'should default the the taken_at before date' do
      asset = FactoryGirl.create(:asset)
      FactoryGirl.create(:reading, :taken_at => (DateTime.now - 15.hours), :asset => asset)
      before_reading = FactoryGirl.create(:reading, :taken_at => (DateTime.now - 45.minutes), :asset => asset)
      reading = FactoryGirl.create(:reading, :taken_at => DateTime.now, :asset => asset)

      reading.previous_reading.should eq(before_reading)
    end

    it 'should use created_at as a backup' do
      asset = FactoryGirl.create(:asset)
      before_reading = FactoryGirl.create(:reading, :asset => asset)
      reading = FactoryGirl.create(:reading, :asset => asset)
      before_reading.created_at = DateTime.now
      reading.created_at = (DateTime.now - 30.minutes)
      before_reading.save
      reading.save

      before_reading.previous_reading.should eq(reading)
    end

    it 'should return nil if there is no reading before this one' do
      asset = FactoryGirl.create(:asset)
      FactoryGirl.create(:reading, :taken_at => (DateTime.now - 15.hours), :asset => asset)
      FactoryGirl.create(:reading, :taken_at => (DateTime.now - 45.minutes), :asset => asset)
      reading = FactoryGirl.create(:reading, :taken_at => DateTime.now, :asset => asset)

      lone_reading = FactoryGirl.create(:reading, :asset => FactoryGirl.create(:asset))
      lone_reading.previous_reading.should be_nil
    end

    it 'should be able to go farther back into previous readings' do
      asset = FactoryGirl.create(:asset)
      earliest = FactoryGirl.create(:reading, :taken_at => (DateTime.now - 15.hours), :asset => asset)
      earlier = FactoryGirl.create(:reading, :taken_at => (DateTime.now - 45.minutes), :asset => asset)
      reading = FactoryGirl.create(:reading, :taken_at => DateTime.now, :asset => asset)

      reading.previous_reading(2).should eq(earliest)
    end

  end

  describe 'mark_limits_as_json' do
    locations_monitor_class = nil, monitor_limit = nil, other_monitor_limit = nil,
        monitor_point = nil, other_monitor_point = nil,
        upper_reading = nil, lower_reading = nil, both_reading = nil

    before(:each) do
      locations_monitor_class = FactoryGirl.create(:locations_monitor_class)
      monitor_point = FactoryGirl.create(:monitor_point, :name => 'Methane')
      other_monitor_point = FactoryGirl.create(:monitor_point, :name => 'Oxygen')
      monitor_limit = FactoryGirl.create(:monitor_limit,
                                         :monitor_point => monitor_point,
                                         :locations_monitor_class => locations_monitor_class,
                                         :lower_limit => 200,
                                         :upper_limit => 400)
      other_monitor_limit = FactoryGirl.create(:monitor_limit,
                                               :monitor_point => other_monitor_point,
                                               :locations_monitor_class => locations_monitor_class,
                                               :lower_limit => 600,
                                               :upper_limit => 900)
      upper_reading = FactoryGirl.create(:reading, :data => {'Methane' => 500, 'Oxygen' => 700})
      lower_reading = FactoryGirl.create(:reading, :data => {'Methane' => 300, 'Oxygen' => 500})
      both_reading = FactoryGirl.create(:reading, :data => {'Methane' => 100, 'Oxygen' => 1000})
    end

    it 'should just return the reading as_json if there are no limits that apply' do
      reading = FactoryGirl.create(:reading)
      reading.mark_limits_as_json(locations_monitor_class.id).should eq(reading.as_json)
    end

    it 'should return the reading with an upper limits array that include the key if a monitor point breaks the upper limit' do
      reading = upper_reading.mark_limits_as_json(locations_monitor_class.id)
      reading[:lower_limits].should be_nil
      reading[:upper_limits].size.should eq (1)
      reading[:upper_limits][0].should eq('Methane')
    end

    it 'should return the reading with a lower_limits array that include the key if a monitor point breaks the lower limit' do
      reading = lower_reading.mark_limits_as_json(locations_monitor_class.id)
      reading[:upper_limits].should be_nil
      reading[:lower_limits].size.should eq (1)
      reading[:lower_limits][0].should eq('Oxygen')
    end

    it 'should throw blank values in the lower limit array if there is a key defined' do
      reading = FactoryGirl.create(:reading, :data => {'Methane' => '', 'Oxygen' => 500}).mark_limits_as_json(locations_monitor_class.id)
      reading[:upper_limits].should be_nil
      reading[:lower_limits].size.should eq (2)
      reading[:lower_limits][0].should eq('Methane')
      reading[:lower_limits][1].should eq('Oxygen')
    end

    it 'should throw on upper and lower limits for a reading that qualifies for both' do
      reading = both_reading.mark_limits_as_json(locations_monitor_class.id)
      reading[:lower_limits].size.should eq(1)
      reading[:lower_limits][0].should eq('Methane')
      reading[:upper_limits].size.should eq(1)
      reading[:upper_limits][0].should eq('Oxygen')
    end

    it 'should throw monitor limits in the cache for the point' do
      monitor_limit_cache = {}
      both_reading.mark_limits_as_json(locations_monitor_class.id, monitor_limit_cache)
      monitor_limit_cache['Methane']["id"].should eq(monitor_limit.id)
      monitor_limit_cache['Oxygen']["id"].should eq(other_monitor_limit.id)
    end

  end

  describe 'add_calculations_as_json' do
    locations_monitor_class = nil

    before(:each) do
      height = FactoryGirl.create(:asset_property, :name => 'Height')
      weight = FactoryGirl.create(:asset_property, :name => 'Weight Long')
      asset = FactoryGirl.create(:asset)
      asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => height, :value => 15)
      asset.asset_property_values << FactoryGirl.create(:asset_property_value, :asset_property => weight, :value => -100.3)
      reading.asset = asset
      reading.data = {'Balance Gas' => 78, 'Methane' => 18, 'Toxic Waste' => 1010.5}
      reading.save
      locations_monitor_class = FactoryGirl.create(:deluxe_locations_monitor_class)
      locations_monitor_class.custom_monitor_calculations << FactoryGirl.create(:custom_monitor_calculation, :name => 'Coolness', :value => 'asset[Height] * data[Toxic Waste]')
      locations_monitor_class.custom_monitor_calculations << FactoryGirl.create(:custom_monitor_calculation, :name => 'Hottness', :value => '10 - 4')
      locations_monitor_class.save
    end

    it 'should just return the reading as_json if there is no locations_monitor_class passed in' do
      reading.add_calculations_as_json(nil).should eq(reading.as_json)
    end

    it 'should return the reading as json if there are no calculations on the lmc' do
      reading.add_calculations_as_json(FactoryGirl.create(:deluxe_locations_monitor_class)).should eq(reading.as_json)
    end

    it 'should add the calculations to the readings data' do
      reading.add_calculations_as_json(locations_monitor_class)[:data].should eq({"Balance Gas" => 78, "Methane" => 18, "Toxic Waste" => 1010.5, "Coolness" => '15157.50', "Hottness" => '6.00'})
    end

  end

  describe 'as_json' do
    it 'should provide a parsed version of the data attribute' do
      reading.as_json['data'].should eq("{\"name\":\"Georgie\",\"location\":\"NYC\",\"age\":67}")
    end
  end

end