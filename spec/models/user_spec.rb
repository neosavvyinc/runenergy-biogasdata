require 'spec_helper'

describe User do

  let :customer do
    FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
  end

  let :overseer do
    FactoryGirl.create(:user, :user_type => UserType.OVERSEER)
  end

  let :worker do
    FactoryGirl.create(:user, :user_type => UserType.WORKER)
  end

  describe 'all_locations' do
    location_a = nil, location_b = nil, location_c = nil

    let :user_a do
      FactoryGirl.create(:user)
    end

    let :user_b do
      FactoryGirl.create(:user)
    end

    let :user_c do
      FactoryGirl.create(:user)
    end

    let :user_group_a do
      ug = FactoryGirl.create(:user_group)
      ug.users << user_a
      ug
    end

    let :user_group_c do
      ug = FactoryGirl.create(:user_group)
      ug.users << user_c
      ug
    end

    before(:each) do
      location_a = FactoryGirl.create(:location, :site_name => 'Stubs Landfill')
      location_a.user_groups << user_group_a
      location_b = FactoryGirl.create(:location, :site_name => 'Irish Pub')
      location_b.users << user_b
      location_b.user_groups << user_group_c
      location_c = FactoryGirl.create(:location, :site_name => 'Michael Jordan')
      location_c.users << user_c
    end

    it 'should return all the locations in the db for an overseer' do
      overseer.all_locations.size.should eq(3)
      overseer.all_locations.include?(location_a).should be_true
      overseer.all_locations.include?(location_b).should be_true
      overseer.all_locations.include?(location_c).should be_true
    end

    it 'should return an empty array if the current user has no locations assigned' do
      FactoryGirl.create(:user).all_locations.should eq([])
    end

    it 'should return all the locations assigned to a user' do
      locations = user_b.all_locations
      locations.size.should eq(1)
      locations.first.site_name.should eq('Irish Pub')
    end

    it 'should return all the locations assigned to a users groups' do
      locations = user_a.all_locations
      locations.size.should eq(1)
      locations.first.site_name.should eq('Stubs Landfill')
    end

    it 'should return all locations assigned to a user and a users groups' do
      locations = user_c.all_locations
      locations.size.should eq(2)
      locations[0].site_name.should eq('Michael Jordan')
      locations[1].site_name.should eq('Irish Pub')
    end
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

  describe 'is_worker?' do
    it 'should return true for a worker user' do
      worker.is_worker?.should be_true
    end
  end

end