require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

end
