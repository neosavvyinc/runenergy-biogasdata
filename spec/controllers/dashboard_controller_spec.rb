require "spec_helper"

describe DashboardController do

  describe 'read_flare_deployments' do

    let :flare_deployments do
      [FactoryGirl.create(:flare_deployment, :client_flare_unique_identifier => "Mike"),
       FactoryGirl.create(:flare_deployment, :client_flare_unique_identifier => "Thomas"),
       FactoryGirl.create(:flare_deployment, :client_flare_unique_identifier => "Robert")]
    end

    before :each do
      flare_deployments.should_not be_nil
    end

    describe 'overseer' do
      login_overseer

      it 'should return all of the flare deployments if the user is not a customer' do
        xhr :get, :read_flare_deployments
        response.should_not be_nil
      end
    end

    describe 'customer' do
      login_customer

      it 'should return just the customers flare deployments if the user is a customer' do
      end

    end

  end


end