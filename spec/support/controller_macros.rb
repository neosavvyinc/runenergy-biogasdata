module ControllerMacros
  include Devise::TestHelpers

  def login_overseer
    before(:each) do
      @user ||= FactoryGirl.create(:user)
      sign_in @user
    end
  end

  def login_customer
    before(:each) do
      @user ||= FactoryGirl.create(:user)
      sign_in @user
    end
  end
end