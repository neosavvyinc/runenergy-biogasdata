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

  let :existing_asset do
    FactoryGirl.create(:asset, :location => location_b, :monitor_class => location_b.monitor_classes[0], :unique_identifier => '25OR624')
  end

  let :existing_field_log do
    FactoryGirl.create(:field_log, :data => {'name' => 'Deanna'})
  end

  lmc_a = nil, lmc_b = nil

  before :each do
    existing_field_log.should_not be_nil
    lmc_a = gimme_monitor_class(location_a, 3, 7)
    lmc_b = gimme_monitor_class(location_b, 10, 2)
    existing_asset.should_not be_nil
  end

  describe 'token' do

    describe 'create' do
      it 'should return an error with status 400 if the email is nil' do
        post "#{prefix}token/create", :password => '6789'
        response.status.should eq(400)
      end

      it 'should return an error with status 4oo if the password is nil' do
        post "#{prefix}token/create", :email => 'shortcheese@shortcheese.com'
        response.status.should eq(400)
      end

      it 'should respond with a status 401 if it does not find the user by email' do
        post "#{prefix}token/create", :email => 'shortcheese@shortcheese.com', :password => '6789'
        response.status.should eq(401)
      end

      it 'should create an authentication token for the user when it is assured the user exists' do
        post "#{prefix}token/create", :email => user.email, :password => user.password
        User.find(user.id).authentication_token.should_not be_nil
      end

      it 'should return a status 401 if the password is invalid' do
        post "#{prefix}token/create", :email => user.email, :password => 'somethingnotcorrect'
        response.status.should eq(401)
      end

      it 'should return the authentication token with a status 200 if the password is valid' do
        post "#{prefix}token/create", :email => user.email, :password => user.password
        response.status.should eq(201)
        JSON.parse(response.body)['token'].should eq(user.authentication_token)
      end
    end

    describe 'destroy' do
      it 'should return a 404 if it does not find the user it needs to destroy' do
        post "#{prefix}token/destroy", :authentication_token => '5446'
        response.status.should eq(404)
      end

      it 'should return a status 200 if the user is found via token' do
        post "#{prefix}token/destroy", :authentication_token => user.authentication_token
        response.status.should eq(201)
      end

      it 'should reset the users token and return the old one' do
        auth_token = user.authentication_token
        post "#{prefix}token/destroy", :authentication_token => user.authentication_token
        JSON.parse(response.body)['token'].should eq(auth_token)
        User.find(user.id).authentication_token.should_not eq(auth_token)
      end
    end

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
      parsed_response[1]['locations_monitor_classes'].size.should eq(1)
      parsed_response[1]['locations_monitor_classes'][0]['id'].should eq(lmc_b.id)
    end

    it 'should include monitor_points on each locations_monitor_class' do
      get "#{prefix}sites", :authentication_token => user.authentication_token
      lmc_aa = JSON.parse(response.body)[0]['locations_monitor_classes'][0]
      lmc_bb = JSON.parse(response.body)[1]['locations_monitor_classes'][0]
      lmc_aa['monitor_points'].size.should eq(3)
      lmc_bb['monitor_points'].size.should eq(10)
    end

    it 'should include field_log_points on each locations_monitor_class' do
      get "#{prefix}sites", :authentication_token => user.authentication_token
      lmc_aa = JSON.parse(response.body)[0]['locations_monitor_classes'][0]
      lmc_bb = JSON.parse(response.body)[1]['locations_monitor_classes'][0]
      lmc_aa['field_log_points'].size.should eq(7)
      lmc_bb['field_log_points'].size.should eq(2)
    end

    describe 'class_ids' do

      liquid_guaging = nil, gas_readings = nil, both_location = nil, liquid_location = nil, gas_location = nil

      before(:each) do
        liquid_guaging = FactoryGirl.create(:monitor_class, :name => 'Liquid Guaging')
        gas_readings = FactoryGirl.create(:monitor_class, :name => 'Gas Readings')
        other_class = FactoryGirl.create(:monitor_class, :name => 'Other')
        both_location = FactoryGirl.create(:location)
        both_location.assets << FactoryGirl.create(:asset, :monitor_class => liquid_guaging)
        both_location.assets << FactoryGirl.create(:asset, :monitor_class => gas_readings)
        both_location.assets << FactoryGirl.create(:asset, :monitor_class => other_class)
        both_location.users << user
        both_location.save
        liquid_location = FactoryGirl.create(:location)
        liquid_location.assets << FactoryGirl.create(:asset, :monitor_class => liquid_guaging)
        liquid_location.assets << FactoryGirl.create(:asset, :monitor_class => liquid_guaging)
        liquid_location.assets << FactoryGirl.create(:asset, :monitor_class => other_class)
        liquid_location.users << user
        liquid_location.save
        gas_location = FactoryGirl.create(:location)
        gas_location.assets << FactoryGirl.create(:asset, :monitor_class => gas_readings)
        gas_location.assets << FactoryGirl.create(:asset, :monitor_class => gas_readings)
        gas_location.assets << FactoryGirl.create(:asset, :monitor_class => other_class)
        gas_location.users << user
        gas_location.save
      end

      it 'should be able to filter on a single class_ids param' do
        get "#{prefix}sites", :authentication_token => user.authentication_token, :class_ids => liquid_guaging.id.to_s
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(2)
        parsed_response[0]['assets'].size.should eq(1)
        parsed_response[1]['assets'].size.should eq(2)
      end

      it 'should be able to filter on comma separated class_ids' do
        get "#{prefix}sites", :authentication_token => user.authentication_token, :class_ids => "#{liquid_guaging.id.to_s}, #{gas_readings.id}"
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(3)
        parsed_response[0]['assets'].size.should eq(2)
        parsed_response[1]['assets'].size.should eq(2)
        parsed_response[2]['assets'].size.should eq(2)
      end

      it 'should be able to filter on a single class_ids param as a name' do
        get "#{prefix}sites", :authentication_token => user.authentication_token, :class_ids => gas_readings.name
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(2)
        parsed_response[0]['assets'].size.should eq(1)
        parsed_response[1]['assets'].size.should eq(2)
      end

      it 'should be able to filter on comma separated class_ids as names' do
        get "#{prefix}sites", :authentication_token => user.authentication_token, :class_ids => "#{liquid_guaging.name}, #{gas_readings.name}"
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(3)
        parsed_response[0]['assets'].size.should eq(2)
        parsed_response[1]['assets'].size.should eq(2)
        parsed_response[2]['assets'].size.should eq(2)
      end

    end

  end

  describe 'readings' do

    describe 'get' do

      before(:each) do
        20.times do
          FactoryGirl.create(:reading, :location => location_a, :monitor_class => location_a.monitor_classes[0])
          FactoryGirl.create(:reading, :location => location_b, :monitor_class => location_b.monitor_classes[0])
        end
      end

      it 'should send down an error of status 401 if there is no auth token provided' do
        get "#{prefix}readings", :site_id => 1, :class_id => 1
        response.status.should eq(401)
      end

      it 'should send down an error of status 401 if the auth token is invalid' do
        get "#{prefix}readings", :authentication_token => '5446', :site_id => 1, :class_id => 1
        response.status.should eq(401)
      end

      it 'should send down an error of status 401 if the user is not entitled to the site' do
        get "#{prefix}readings", :authentication_token => user.authentication_token, :site_id => FactoryGirl.create(:location).id, :class_id => 1
        response.status.should eq(401)
      end

      it 'should return 10 readings for the location and monitor class by default' do
        get "#{prefix}readings", :authentication_token => user.authentication_token, :site_id => location_a.id, :class_id => location_a.monitor_classes[0].id
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(10)
        parsed_response.each do |r|
          r['data'].should_not be_nil
        end
      end

      it 'should allow the caller to set the reading count using the params[:count]' do
        get "#{prefix}readings", :authentication_token => user.authentication_token, :site_id => location_a.id, :class_id => location_a.monitor_classes[0].id, :count => 17
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(17)
        parsed_response.each do |r|
          r['data'].should_not be_nil
        end
      end

      it 'should not cause any problems when the count is above the max available' do
        get "#{prefix}readings", :authentication_token => user.authentication_token, :site_id => location_a.id, :class_id => location_a.monitor_classes[0].id, :count => 150
        parsed_response = JSON.parse(response.body)
        parsed_response.size.should eq(20)
        parsed_response.each do |r|
          r['data'].should_not be_nil
        end
      end
    end

    describe 'post' do
      it 'should send down an error of status 401 if there is no auth token provided' do
        post "#{prefix}readings/create", :site_id => 1, :class_id => 1, :field_log => 1, :reading => 1, :asset_unique_identifier => 1, :date_time => 1390612469
        response.status.should eq(401)
      end

      it 'should send down an error of status 401 if the auth token is invalid' do
        post "#{prefix}readings/create", :authentication_token => '5446', :site_id => 1, :class_id => 1, :field_log => 1, :reading => 1, :asset_unique_identifier => 1, :date_time => 1390612469
        response.status.should eq(401)
      end

      it 'should send down an error of status 401 if the user is not entitled to the site' do
        post "#{prefix}readings/create", :authentication_token => user.authentication_token, :site_id => FactoryGirl.create(:location).id, :class_id => 1, :field_log => 1, :reading => 1, :asset_unique_identifier => 1, :date_time => 1390612469
        response.status.should eq(401)
      end

      describe 'valid' do

        before(:each) do
          post "#{prefix}readings/create", :authentication_token => user.authentication_token,
               :site_id => location_b.id, :class_id => location_b.monitor_classes[0].id, :field_log => {'name' => 'Georgie'},
               :reading => {'food' => 'Fish'}, :asset_unique_identifier => '678278JG67', :date_time => 1390612469
        end

        it 'should return an error of 401 if the monitor class and location do not have a defined association' do
          post "#{prefix}readings/create", :authentication_token => user.authentication_token,
               :site_id => location_b.id, :class_id => location_a.monitor_classes[0].id, :field_log => {'name' => 'Georgie'},
               :reading => {'food' => 'Fish'}, :asset_unique_identifier => '678278JG67', :date_time => 1390612469
          response.status.should eq(401)
        end

        it 'should create the reading with the site_id passed in' do
          Reading.find(JSON.parse(response.body)['id']).location_id.should eq(location_b.id)
        end

        it 'should create the reading with the class_id passed in' do
          Reading.find(JSON.parse(response.body)['id']).monitor_class_id.should eq(location_b.monitor_classes[0].id)
        end

        it 'should be able to create a new field_log with the data and apply it to the reading' do
          field_log = Reading.find(JSON.parse(response.body)['id']).field_log
          field_log.id.should_not eq(existing_field_log.id)
        end

        pending 'should be able to lazy load an existing field log with the same data and apply it to the reading' do
          post "#{prefix}readings/create", :authentication_token => user.authentication_token,
               :site_id => location_b.id, :class_id => location_b.monitor_classes[0].id, :field_log => existing_field_log.data,
               :reading => {'food' => 'Fish'}, :asset_unique_identifier => '678278JG67', :date_time => 1390612469
          field_log = Reading.find(JSON.parse(response.body)['id']).field_log
          field_log.id.should eq(existing_field_log.id)
        end

        it 'should be able to create a new asset and apply it to the reading' do
          asset = Reading.find(JSON.parse(response.body)['id']).asset
          asset.id.should_not eq(existing_asset.id)
          asset.unique_identifier.should eq('678278JG67')
        end

        it 'should be able to lazy load an existing asset from the unique identifier and apply it to the reading' do
          post "#{prefix}readings/create", :authentication_token => user.authentication_token,
               :site_id => location_b.id, :class_id => location_b.monitor_classes[0].id, :field_log => {'name' => 'Georgie'},
               :reading => {'food' => 'Fish'}, :asset_unique_identifier => '25OR624', :date_time => 1390612469
          asset = Reading.find(JSON.parse(response.body)['id']).asset
          asset.id.should eq(existing_asset.id)
          asset.unique_identifier.should eq('25OR624')
        end

        it 'should apply the data to the reading' do
          Reading.find(JSON.parse(response.body)['id']).data.should eq({'food' => 'Fish'}.to_json)
        end

        it 'should apply the UTC date to the reading in the date time field' do
          date_time = DateTime.parse(Reading.find(JSON.parse(response.body)['id']).taken_at.to_s)
          date_time.year.should eq(2014)
          date_time.month.should eq(1)
          date_time.day.should eq(25)
          date_time.hour.should eq(1)
          date_time.minute.should eq(14)
          date_time.second.should eq(29)
        end

        it 'should return the newly created reading' do
          reading = JSON.parse(response.body)
          reading['id'].should eq(Reading.last.id)
          reading['data'].should_not be_nil
          reading['taken_at'].should_not be_nil
        end

        it 'should throw an error when passed non UTC date_time format' do
          post "#{prefix}readings/create", :authentication_token => user.authentication_token,
               :site_id => location_b.id, :class_id => location_b.monitor_classes[0].id, :field_log => {'name' => 'Georgie'},
               :reading => {'food' => 'Fish'}, :asset_unique_identifier => '25OR624', :date_time => '2102-14-16'
          response.status.should eq(401)
        end
      end

    end

  end

end