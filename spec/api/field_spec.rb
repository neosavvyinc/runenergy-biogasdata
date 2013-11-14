require 'spec_helper'

describe Field::API do

  prefix = '/field/v1/'

  let :monitor_class_a do
    FactoryGirl.create(:monitor_class)
  end

  let :monitor_class_b do
    FactoryGirl.create(:monitor_class)
  end

  before :each do
    monitor_class_a.should_not be_nil
    monitor_class_b.should_not be_nil
  end

  describe 'monitor_classes' do

    it 'should return all the monitor classes in a basic get request' do
      get "#{prefix}monitor_classes"
      response.body.should_not be_nil
      parsed_response = JSON.parse response.body
      parsed_response[0]["id"].should eq(monitor_class_a.id)
      parsed_response[1]["id"].should eq(monitor_class_b.id)
    end

  end

end