require 'spec_helper'

describe FieldLog do

  let :field_log do
    FactoryGirl.create(:field_log, :data => {:name => 'George'})
  end

  before(:each) do
    field_log.should_not be_nil
  end

  describe 'self.find_or_create_by_data' do

    it 'should find it if the item exists with the data' do
      my_field_log = FieldLog.find_or_create_by_data({:name => 'George'})
      my_field_log.id.should eq(field_log.id)
    end

    it 'should create it if the item does not exist with the data' do
      my_field_log = FieldLog.find_or_create_by_data({:name => 'Tim'})
      my_field_log.id.should_not eq(field_log.id)
    end

    it 'should throw an error when no valid data is passed in' do
      expect {
        FieldLog.find_or_create_by_data(nil)
      }.to raise_error
    end

  end

  describe 'display_name' do

    it 'should return No Data Defined if there is no data' do
      fl = FactoryGirl.create(:field_log, :data => '{}')
      fl.display_name.should eq('No Data Defined')
    end

    it 'should return the csv of data if defined' do
      field_log.display_name.should eq('name: George')
    end

  end

  describe 'as_json' do

    it 'should merge a json parsed version of the data with the normal properties' do
      json = field_log.as_json
      json.should_not be_nil
      json['data']['name'].should_not be_nil
      json['data']['name'].should_not eq('')
    end

  end
end
