require 'spec_helper'

describe Field::API do

  prefix = '/field/v1/'

  def gimme_monitor_class(location, mp_count, fl_count)
    lmc = FactoryGirl.create(:locations_monitor_class, :location => location, :monitor_class => FactoryGirl.create(:monitor_class))
    mp_count.times do
      lmc.monitor_points << FactoryGirl.create(:monitor_point)
    end
    fl_count.times do
      lmc.field_log_points << FactoryGirl.create(:field_log_point)
    end
    lmc
  end

  let :user do
    FactoryGirl.create(:user)
  end

  let :user_group do
    ug = FactoryGirl.create(:user_group)
    ug.users << user
    ug
  end

  let :location_a do
    l = FactoryGirl.create(:location)
    l.users << user
    l
  end

  let :location_b do
    l = FactoryGirl.create(:location)
    l.user_groups << user_group
    l
  end

  lmc_a = nil, lmc_b = nil

  before :each do
    lmc_a = gimme_monitor_class(location_a, 3, 7)
    lmc_b = gimme_monitor_class(location_b, 10, 2)
  end

  describe 'sites' do

    it 'should send down an error of status 401 if there is no auth token provided' do
      get "#{prefix}sites"
      response.status.should eq(401)
    end

    it 'should send down an error of status 401 if the auth token is invalid' do
      get "#{prefix}sites", :authentication_token => '5446'
      response.status.should eq(401)
    end

    it 'should return all the locations for the current user if they are authenticated' do
      get "#{prefix}sites", :authentication_token => user.authentication_token
      JSON.parse(response.body).size.should eq(2)
    end

    it 'should include locations_monitor_classes on each location' do
      get "#{prefix}sites", :authentication_token => user.authentication_token
      parsed_response = JSON.parse(response.body)
      parsed_response[0]['locations_monitor_classes'].size.should eq(1)
      parsed_response[0]['locations_monitor_classes'][0]['id'].should eq(lmc_a.id)
    end

    it 'should include monitor_points on each locations_monitor_class' do
      
    end

    it 'should include field_log_points on each locations_monitor_class' do

    end
  end

end