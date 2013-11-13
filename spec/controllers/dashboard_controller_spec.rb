require 'spec_helper'
require 'json'

describe DashboardController do

  describe 'read_flare_deployments' do

    let :jordan do
      FactoryGirl.create(:user, :name => "Jordan Frankfurt", :user_type => UserType.CUSTOMER)
    end

    let :trevor do
      FactoryGirl.create(:user, :name => "Trevor Ewen", :user_type => UserType.CUSTOMER)
    end

    let :flare_deployments do
      [FactoryGirl.create(:flare_deployment, :customer => jordan),
       FactoryGirl.create(:flare_deployment, :customer => trevor),
       FactoryGirl.create(:flare_deployment, :customer => trevor)]
    end

    before :each do
      flare_deployments.should_not be_nil
    end

    describe 'overseer' do
      login_overseer

      it 'should return all of the flare deployments if the user is not a customer' do
        xhr :get, :read_flare_deployments
        parsed_response = JSON.parse response.body
        parsed_response.size.should eq(3)
        parsed_response[0]["customer_id"].should eq(jordan.id)
        parsed_response[1]["customer_id"].should eq(trevor.id)
        parsed_response[2]["customer_id"].should eq(trevor.id)
      end
    end

    describe 'customer' do
      before(:each) do
        sign_in trevor
      end

      it 'should return just the customers flare deployments if the user is a customer' do
        xhr :get, :read_flare_deployments
        parsed_response = JSON.parse response.body
        parsed_response.size.should eq(2)
        parsed_response[0]["id"].should eq flare_deployments[1].id
        parsed_response[0]["customer_id"].should eq(trevor.id)
        parsed_response[1]["id"].should eq flare_deployments[2].id
        parsed_response[1]["customer_id"].should eq(trevor.id)
      end

    end

  end


end