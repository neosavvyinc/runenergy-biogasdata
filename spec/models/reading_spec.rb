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
        Reading.process_edited_collection(nil, {}, {}, [], 10, 11, 12)
      }.to raise_error
    end

    it 'should raise an error if the site_id is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], '', 11, 12)
      }.to raise_error
    end

    it 'should raise an error if the monitor_class_id is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], 10, nil, 12)
      }.to raise_error
    end

    it 'should raise an error if the asset_column_name is blank' do
      expect {
        Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [], 10, 11, '')
      }.to raise_error
    end

    it 'should return no readings if all rows passed in ared deleted' do
      my_readings = Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [1, 2, 3], 7, 8, 9)
      my_readings.should eq([])
    end

    it 'should add a row to new readings for each row that is not in a deleted index' do
      #Stub out method
      expect(Reading).to receive(:map_and_validate_columns).twice.and_return({'data_no' => rand(30)})

      #Call
      my_readings = Reading.process_edited_collection(['Tom', 'Charlie', 'Jerry'], {}, {}, [2], 1, monitor_class.id, 3)
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

  describe 'mark_limits_as_json' do
    location = nil, monitor_limit = nil, other_monitor_limit = nil,
        monitor_point = nil, other_monitor_point = nil,
        upper_reading = nil, lower_reading = nil, both_reading = nil

    before(:each) do
      location = FactoryGirl.create(:location)
      monitor_point = FactoryGirl.create(:monitor_point, :name => 'Methane')
      other_monitor_point = FactoryGirl.create(:monitor_point, :name => 'Oxygen')
      monitor_limit = FactoryGirl.create(:monitor_limit,
                                         :monitor_point => monitor_point,
                                         :location => location,
                                         :lower_limit => 200,
                                         :upper_limit => 400)
      other_monitor_limit = FactoryGirl.create(:monitor_limit,
                                               :monitor_point => other_monitor_point,
                                               :location => location,
                                               :lower_limit => 600,
                                               :upper_limit => 900)
      upper_reading = FactoryGirl.create(:reading, :data => {'Methane' => 500, 'Oxygen' => 700})
      lower_reading = FactoryGirl.create(:reading, :data => {'Methane' => 300, 'Oxygen' => 500})
      both_reading = FactoryGirl.create(:reading, :data => {'Methane' => 100, 'Oxygen' => 1000})
    end

    it 'should just return the reading as_json if there are no limits that apply' do
      reading = FactoryGirl.create(:reading)
      reading.mark_limits_as_json(location.id).should eq(reading.as_json)
    end

    it 'should return the reading with an upper limits array that include the key if a monitor point breaks the upper limit' do
      reading = upper_reading.mark_limits_as_json(location.id)
      reading[:lower_limits].should be_nil
      reading[:upper_limits].size.should eq (1)
      reading[:upper_limits][0].should eq('Methane')
    end

    it 'should return the reading with a lower_limits array that include the key if a monitor point breaks the lower limit' do
      reading = lower_reading.mark_limits_as_json(location.id)
      reading[:upper_limits].should be_nil
      reading[:lower_limits].size.should eq (1)
      reading[:lower_limits][0].should eq('Oxygen')
    end

    it 'should throw blank values in the lower limit array if there is a key defined' do
      reading = FactoryGirl.create(:reading, :data => {'Methane' => '', 'Oxygen' => 500}).mark_limits_as_json(location.id)
      reading[:upper_limits].should be_nil
      reading[:lower_limits].size.should eq (2)
      reading[:lower_limits][0].should eq('Methane')
      reading[:lower_limits][1].should eq('Oxygen')
    end

    it 'should throw on upper and lower limits for a reading that qualifies for both' do
      reading = both_reading.mark_limits_as_json(location.id)
      reading[:lower_limits].size.should eq(1)
      reading[:lower_limits][0].should eq('Methane')
      reading[:upper_limits].size.should eq(1)
      reading[:upper_limits][0].should eq('Oxygen')
    end

    it 'should throw monitor limits in the cache for the point' do
      monitor_limit_cache = {}
      both_reading.mark_limits_as_json(location.id, monitor_limit_cache)
      monitor_limit_cache['Methane']["id"].should eq(monitor_limit.id)
      monitor_limit_cache['Oxygen']["id"].should eq(other_monitor_limit.id)
    end

  end

  describe 'as_json' do
    it 'should provide a parsed version of the data attribute' do
      reading.as_json['data'].should eq("{\"name\":\"Georgie\",\"location\":\"NYC\",\"age\":67}")
    end
  end

end