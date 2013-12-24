require 'spec_helper'

describe AjaxHelp do

  include AjaxHelp

  describe 'ajax_value_or_nil' do

    it 'should have 5 test cases!' do
      
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

end