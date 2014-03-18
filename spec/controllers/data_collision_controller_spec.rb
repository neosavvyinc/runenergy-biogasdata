require 'spec_helper'
require 'json'

describe DataCollisionController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :customer do
    FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
  end

  location_a = nil, location_b = nil, asset_a = nil, asset_b = nil, data_collision_a = nil, data_collision_b = nil

  before(:each) do
    monitor_class = FactoryGirl.create(:monitor_class, :name => 'Steam Punk')
    location_a = FactoryGirl.create(:location, :site_name => 'Lemmy-Ville', :locations_monitor_class => FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class))
    location_b = FactoryGirl.create(:location, :site_name => 'Dio-Ville', :locations_monitor_class => FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class))
    location_a.users << customer
    location_b.users << customer
    asset_a = FactoryGirl.create(:asset)
    asset_b = FactoryGirl.create(:asset)
    location_a.assets << asset_a
    location_b.assets << asset_b
    data_collision_a = FactoryGirl.create(:data_collision)
    data_collision_a.readings << FactoryGirl.create(:reading, :asset => asset_a)
    data_collision_a.readings << FactoryGirl.create(:reading, :asset => asset_a)
    data_collision_b = FactoryGirl.create(:data_collision)
    data_collision_b.readings << FactoryGirl.create(:reading, :asset => asset_b)
    data_collision_b.readings << FactoryGirl.create(:reading, :asset => asset_b)

    sign_in customer
  end

  describe 'index' do

  end

end