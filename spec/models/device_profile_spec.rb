require 'spec_helper'

describe DeviceProfile do

  let :device_profile do
    FactoryGirl.create(:device_profile)
  end

  let :user_group_a do
    FactoryGirl.create(:user_group)
  end

  let :user_group_b do
    FactoryGirl.create(:user_group)
  end

  let :user_a do
    FactoryGirl.create(:user)
  end

  let :user_b do
    FactoryGirl.create(:user)
  end

  let :user_c do
    FactoryGirl.create(:user)
  end

  let :user_d do
    FactoryGirl.create(:user)
  end

  describe 'unique_users' do
    it 'should return all the users from groups only if that is the case' do
      user_group_a.users << user_a
      user_group_b.users << user_b
      device_profile.user_groups << user_group_a
      device_profile.user_groups << user_group_b

      ar = device_profile.unique_users
      ar.size.should eq(2)
      ar.should include(user_a)
      ar.should include(user_b)
    end

    it 'should return all the users that are assigned only if that is the case' do
      device_profile.users << user_c
      device_profile.users << user_d
      device_profile.users << user_a

      ar = device_profile.unique_users
      ar.size.should eq(3)
      ar.should include(user_c)
      ar.should include(user_d)
      ar.should include(user_a)
    end

    it 'should be able to remove duplicates' do
      user_group_b.users << user_b
      device_profile.user_groups << user_group_b
      device_profile.users << user_b

      ar = device_profile.unique_users
      ar.size.should eq(1)
      ar.should include(user_b)
    end

    it 'should be able to combine users and user groups' do
      user_group_a.users << user_a
      user_group_b.users << user_b
      user_group_b.users << user_d
      device_profile.user_groups << user_group_a
      device_profile.user_groups << user_group_b
      device_profile.users << user_c
      device_profile.users << user_a

      ar = device_profile.unique_users
      ar.size.should eq(4)
      ar.should include(user_a)
      ar.should include(user_b)
      ar.should include(user_c)
      ar.should include(user_d)
    end
  end
  
end
