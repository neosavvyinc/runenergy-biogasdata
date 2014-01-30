require 'spec_helper'
require 'json'

describe DashboardController do

  describe 'read_flare_deployments' do

    let :jordan do
      FactoryGirl.create(:user, :name => 'Jordan Frankfurt', :user_type => UserType.CUSTOMER)
    end

    let :trevor do
      FactoryGirl.create(:user, :name => 'Trevor Ewen', :user_type => UserType.CUSTOMER)
    end

    let :flare_deployments do
      [FactoryGirl.create(:flare_deployment, :customer => jordan),
       FactoryGirl.create(:flare_deployment, :customer => trevor),
       FactoryGirl.create(:flare_deployment, :customer => trevor)]
    end

    let :trevors_data do
      [
          FactoryGirl.create(:flare_monitor_data, :flare_specification => flare_deployments[1].flare_specification),
          FactoryGirl.create(:flare_monitor_data, :flare_specification => flare_deployments[1].flare_specification),
      ]
    end

    let :jordans_data do
      [
          FactoryGirl.create(:flare_monitor_data, :flare_specification => flare_deployments[0].flare_specification),
          FactoryGirl.create(:flare_monitor_data, :flare_specification => flare_deployments[0].flare_specification),
      ]
    end

    before :each do
      flare_deployments.should_not be_nil
    end

    describe 'read_current_user' do
      before(:each) do
        sign_in trevor
      end

      it 'should return the current_user object as json' do
        xhr :get, :read_current_user
        response.body.should eq trevor.to_json
      end
    end

    describe 'create_session' do
      before(:each) do
        sign_in jordan
      end

      it 'should add the params to the :constraints key in the session' do
        xhr :post, :create_session, :startDate => 5, :endDate => 4, :startTime => 3, :endTime => 2, :filters => 'Buzz'
        parsed_response = JSON.parse response.body
        parsed_response['constraints'].should_not be_nil
        session[:constraints][:start_date].should eq '5'
        session[:constraints][:end_date].should eq '4'
        session[:constraints][:start_time].should eq '3'
        session[:constraints][:end_time].should eq '2'
        session[:constraints][:filters].should eq 'Buzz'
      end
    end

    describe 'read_flare_monitor_data' do
      before(:each) do
        trevors_data.should_not be_nil
        jordans_data.should_not be_nil
        sign_in trevor
      end

      describe 'xhr' do
        it 'should return two items for the customer that is logged in with a valid flareSpecificationId' do
          xhr :get, :read_flare_monitor_data, :flareSpecificationId => flare_deployments[1].flare_specification.id
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq 2
        end
      end

      describe 'csv' do

      end
    end

    describe 'overseer' do
      login_overseer

      describe 'read_customers' do
        it 'should return all the customers' do
          xhr :get, :read_customers
          response.body.should eq User.where(:user_type_id => UserType.CUSTOMER.id).to_json
        end
      end

      describe 'read_locations' do

        it 'should return all locations' do
          xhr :get, :read_locations
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq 5
        end

        it 'should include flare_specifications in each location' do
          xhr :get, :read_locations
          parsed_response = JSON.parse response.body
          parsed_response.each do |l|
            l['flare_specifications'].should_not be_nil
          end
        end
      end

      describe 'read_flare_deployments' do
        it 'should return all of the flare deployments if the user is not a customer' do
          xhr :get, :read_flare_deployments
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq(3)
          parsed_response[0]['customer_id'].should eq(jordan.id)
          parsed_response[1]['customer_id'].should eq(trevor.id)
          parsed_response[2]['customer_id'].should eq(trevor.id)
        end
      end

      describe 'read_flare_specifications' do
        it 'should return all flare specifications' do
          xhr :get, :read_flare_specifications
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq(3)
        end

        it 'should map a location onto each flare specification' do
          xhr :get, :read_flare_specifications
          parsed_response = JSON.parse response.body
          parsed_response.each do |l|
            l['location'].should_not be_nil
          end
        end
      end

    end

    describe 'customer' do
      before(:each) do
        sign_in trevor
      end

      describe 'read_customers' do
        it 'should return an empty response' do
          xhr :get, :read_customers
          response.body.should eq ('null')
        end
      end

      describe 'read_locations' do
        it 'should get locations where the current_user has flare_deployments' do
          xhr :get, :read_locations
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq(2)
          (parsed_response[0]['id'] == flare_deployments[1].location.id or
              parsed_response[0]['id'] == flare_deployments[2].location.id).should be_true
          (parsed_response[1]['id'] == flare_deployments[1].location.id or
              parsed_response[1]['id'] == flare_deployments[2].location.id).should be_true
        end

        it 'should include flare_specifications in each location' do
          xhr :get, :read_locations
          parsed_response = JSON.parse response.body
          parsed_response.each do |l|
            l['flare_specifications'].should_not be_nil
          end
        end
      end

      describe 'read_flare_deployments' do
        it 'should return just the customers flare deployments if the user is a customer' do
          xhr :get, :read_flare_deployments
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq(2)
          parsed_response[0]['id'].should eq flare_deployments[1].id
          parsed_response[0]['customer_id'].should eq(trevor.id)
          parsed_response[1]['id'].should eq flare_deployments[2].id
          parsed_response[1]['customer_id'].should eq(trevor.id)
        end
      end

      describe 'read_flare_specifications' do
        it 'should return the flare specifications for the current user' do
          xhr :get, :read_flare_specifications
          parsed_response = JSON.parse response.body
          parsed_response.size.should eq(2)
          parsed_response[0]['id'].should eq flare_deployments[1].flare_specification.id
          parsed_response[1]['id'].should eq flare_deployments[2].flare_specification.id
        end

        it 'should map the location onto the flare_specification' do
          xhr :get, :read_flare_specifications
          parsed_response = JSON.parse response.body
          parsed_response[0]['location']['id'].should eq flare_deployments[1].location.id
          parsed_response[1]['location']['id'].should eq flare_deployments[2].location.id
        end
      end
    end

  end


end