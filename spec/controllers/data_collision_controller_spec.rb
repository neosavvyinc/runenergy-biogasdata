require 'spec_helper'
require 'json'

describe DataCollisionController do

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :customer do
    FactoryGirl.create(:user, :user_type => UserType.CUSTOMER, :edit_permission => true)
  end

  location_a = nil, location_b = nil, asset_a = nil, asset_b = nil, data_collision_a = nil, data_collision_b = nil

  before(:each) do
    monitor_class = FactoryGirl.create(:monitor_class, :name => 'Steam Punk')
    location_a = FactoryGirl.create(:location, :site_name => 'Lemmy-Ville')
    location_b = FactoryGirl.create(:location, :site_name => 'Dio-Ville')
    FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class, :location => location_a)
    FactoryGirl.create(:locations_monitor_class, :monitor_class => monitor_class, :location => location_b)
    location_a.users << customer
    location_b.users << customer
    asset_a = FactoryGirl.create(:asset, :monitor_class => monitor_class, :location => location_a)
    asset_b = FactoryGirl.create(:asset, :monitor_class => monitor_class, :location => location_b)
    data_collision_a = FactoryGirl.create(:data_collision)
    data_collision_a.readings << FactoryGirl.create(:reading, :asset => asset_a)
    data_collision_a.readings << FactoryGirl.create(:reading, :asset => asset_a)
    data_collision_b = FactoryGirl.create(:data_collision)
    data_collision_b.readings << FactoryGirl.create(:reading, :asset => asset_b)
    data_collision_b.readings << FactoryGirl.create(:reading, :asset => asset_b)

    sign_in customer
  end

  describe 'index' do

    it 'should set the instance variable of size 2 based on the users locations' do
      get :index
      data_collision_blocks = controller.instance_variable_get(:@data_collision_blocks)
      data_collision_blocks.size.should eq(2)
    end

    it 'should throw the named locations in the instance variable' do
      get :index
      data_collision_blocks = controller.instance_variable_get(:@data_collision_blocks)
      data_collision_blocks['Lemmy-Ville - Steam Punks'].should_not be_nil
      data_collision_blocks['Dio-Ville - Steam Punks'].should_not be_nil
    end

    it 'should throw the collisions as an array within the name indices' do
      get :index
      data_collision_blocks = controller.instance_variable_get(:@data_collision_blocks)
      data_collision_blocks['Lemmy-Ville - Steam Punks'].size.should eq(1)
      data_collision_blocks['Lemmy-Ville - Steam Punks'].include?(data_collision_a).should be_true
      data_collision_blocks['Dio-Ville - Steam Punks'].size.should eq(1)
      data_collision_blocks['Dio-Ville - Steam Punks'].include?(data_collision_b).should be_true
    end

    it 'should redirect in the case of a customer without edit permissions' do
      sign_in FactoryGirl.create(:user, :user_type => UserType.CUSTOMER, :edit_permission => false)
      get :index
      response.should redirect_to 'data_analysis#index'
    end
    
  end
  
  describe 'resolve' do

    reading_a = nil, reading_b = nil, reading_c = nil, data_collision = nil
    before(:each) do
      data_collision = FactoryGirl.create(:data_collision)
      reading_a = FactoryGirl.create(:reading, :data_collision => data_collision)
      reading_b = FactoryGirl.create(:reading)
      reading_c = FactoryGirl.create(:reading, :data_collision => data_collision)
    end

    it 'should return a 400 error when not passed a collision_id param' do
      xhr :get, :resolve, :reading_id => reading_a.id
      response.status.should eq(400)
    end

    it 'should return a 400 error when not passed a reading_id param' do
      xhr :get, :resolve, :collision_id => data_collision.id
      response.status.should eq(400)
    end

    it 'should return a 400 error if the collision_id and reading_id are not matched' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_b.id
      response.status.should eq(400)
    end

    it 'should return status 200 when it manages to remove the collision' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_a.id
      parsed_response = JSON.parse(response.body)
      parsed_response
    end

    it 'should return the removed collision with readings as json' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_a.id
      parsed_response = JSON.parse(response.body)
      parsed_response['id'].should eq(data_collision.id)
    end

    it 'should remove the collision upon completion' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_a.id
      DataCollision.where(:id => data_collision.id).first.should be_nil
    end

    it 'should select the resolution reading upon completion, removing the collision_id prop' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_c.id
      Reading.find(reading_c.id).data_collision_id.should be_nil
    end

    it 'should delete the other readings upon completion' do
      xhr :get, :resolve, :collision_id => data_collision.id, :reading_id => reading_c.id
      Reading.where(:id => reading_a.id).first.should be_nil
    end
    
  end

end