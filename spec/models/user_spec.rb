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

  describe 'all_operators' do

    let :user_group do
      ug = FactoryGirl.create(:user_group)
      ug.users << worker
      ug
    end

    let :location do
      l = FactoryGirl.create(:location)
      l.users << customer
      l.user_groups << user_group
      l
    end

    let :location_other do
      l = FactoryGirl.create(:location)
      l.users << worker
      l.users << user_c
      l
    end

    let :user_b do
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
    end

    let :user_c do
      FactoryGirl.create(:user, :user_type => UserType.CUSTOMER)
    end

    before(:each) do
      customer.should_not be_nil
      user_b.should_not be_nil
      user_c.should_not be_nil
      location.should_not be_nil
      location_other.should_not be_nil
    end

    it 'should return all users of type customer for an overseer' do
      overseer.all_operators.size.should eq(3)
    end

    it 'should return the customers of locations that the user has access to in another case' do
      customer.all_operators.size.should eq(1)
      customer.all_operators[0].should eq(customer)
    end

    it 'should return the locations customers to which the user has access to for a worker type of user' do
      worker.all_operators.size.should eq(2)
      worker.all_operators.include?(customer)
      worker.all_operators.include?(user_c)
    end

  end

  describe 'all_locations' do
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

  describe 'is_entitled_to?' do
    it 'should return false if there is no location with the id' do
      user_a.is_entitled_to?(9999).should be_false
    end

    it 'should return false for nil' do
      user_b.is_entitled_to?(nil).should be_false
    end

    it 'should return true for a location the user is entitled to' do
      user_c.is_entitled_to?(location_c.id.to_s).should be_true
    end
  end

  def can_edit

    it 'should return true if the user has edit permission' do
      FactoryGirl.create(:user, :edit_permission => true).can_edit.should be_true
    end

    it 'should return false if the user does not have edit permission' do
      FactoryGirl.create(:user, :edit_permission => false).can_edit.should be_false
    end

    it 'should return true if one user group has edit permission' do
      user_group_a.edit_permission = true
      user_a.can_edit.should be_true
    end

    it 'should return false if all user groups lack permission' do
      user_group_c.edit_permission = false
      user_c.can_edit.should be_false
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