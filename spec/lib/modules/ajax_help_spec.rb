require 'spec_helper'

describe AjaxHelp do

  include AjaxHelp

  describe 'ajax_value_or_nil' do

    it 'should return nil for nil' do
      ajax_value_or_nil(nil).should be_nil
    end

    it 'should return nil for an empty string' do
      ajax_value_or_nil('').should be_nil
    end

    it 'should return nil for the "null" string' do
      ajax_value_or_nil('null').should be_nil
    end

    it 'should return nil for the "undefined" string' do
      ajax_value_or_nil('undefined').should be_nil
    end

    it 'should return the value for a number (including 0)' do
      ajax_value_or_nil(5).should eq(5)
      ajax_value_or_nil(0).should eq(0)
    end

    it 'should return the value for a string' do
      ajax_value_or_nil('Terrence').should eq('Terrence')
    end

    it 'should return the value for an object' do
      ajax_value_or_nil({}).should eq({})
    end
    
  end
  
  describe 'date_time_from_js' do
    it 'should convert a YYYY-MM-DD date to a datetime object with the date' do
      date_time = date_time_from_js('2011-09-18')
      date_time.year.should eq(2011)
      date_time.month.should eq(9)
      date_time.day.should eq(18)
    end

    it 'should convert a similar date with time to a datetime object' do
      date_time = date_time_from_js('2011-09-18', '11:20:15')
      date_time.year.should eq(2011)
      date_time.month.should eq(9)
      date_time.day.should eq(18)
      date_time.hour.should eq(11)
      date_time.minute.should eq(20)
      date_time.second.should eq(15)
    end

    it 'should raise an error when date is nil' do
      expect {
        date_time_from_js(nil)
      }.to raise_error
    end
  end

  describe 'date_time_or_nil' do

    it 'should return nil for nil' do
      date_time_or_nil(nil).should be_nil
    end

    it 'should parse the time since epoch date' do
      date_time_or_nil(1395630621).should eq(DateTime.strptime('1395630621', '%s'))
    end

  end

end