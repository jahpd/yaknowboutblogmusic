require 'test_helper'

class UsersControllerTest < ActionController::TestCase
 
  setup do
    @controller = Devise::RegistrationsController.new
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end  
  
  test "should GET /users/sign_up" do
    get :new
    assert_response :sucess
  end

end
