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

    it 'should raise an error if the collection is nil' do
      expect {
        Reading.process_edited_collection(nil, {}, {}, [])
      }.to raise_error
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
          {'Wind Mill' => monitor_point.id, 'Georgia Mud' => monitor_point_b.id},
          {},
          {}
      )
      data.should eq({'Sequestration' => 67, 'Charles Bronson' => 'Hello Friends'})
    end

    it 'should be able to delete a monitor point' do
      data = Reading.map_and_validate_columns(
          {'Wind Mill' => 67, 'Georgia Mud' => 'Hello Friends'},
          {'Wind Mill' => monitor_point.id, 'Georgia Mud' => monitor_point_b.id},
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

  describe 'as_json' do
    it 'should provide a parsed version of the data attribute' do
      reading.as_json['data'].should eq("{\"name\":\"Georgie\",\"location\":\"NYC\",\"age\":67}")
    end
  end

end