require 'spec_helper'

describe User do

  let :customer do
    FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
  end

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  describe 'is_overseer?' do
    it 'should return true for the overseer user' do
      overseer.is_overseer?.should be_true
    end
  end

  describe 'is_customer?' do
    it 'should return true for the customer user' do
      customer.is_customer?.should be_true
    end
  end

end