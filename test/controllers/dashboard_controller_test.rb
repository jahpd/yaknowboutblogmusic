require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  include Warden::Test::Helpers
  Warden.test_mode!
  fixtures :users

  test "should GET /" do
    get :index
    assert_response :success
  end

 

end
