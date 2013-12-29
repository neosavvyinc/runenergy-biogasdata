require 'spec_helper'

describe UserType do

  describe 'self.OVERSEER' do
    it 'should return the overseer user type' do
      UserType.OVERSEER.name.should eq('OVERSEER')
      UserType.OVERSEER.id.should be > 0
    end
  end

  describe 'self.CUSTOMER' do
    it 'should return the customer user type' do
      UserType.CUSTOMER.name.should eq('CUSTOMER')
      UserType.CUSTOMER.id.should be > 0
    end
  end

  describe 'self.WORKER' do
    it 'should return the worker user type' do
      UserType.WORKER.name.should eq('WORKER')
      UserType.WORKER.id.should be > 0
    end
  end

end