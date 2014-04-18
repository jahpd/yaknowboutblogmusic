require 'test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users

  def setup
    @user = users(:foo)
  end

  test "should have one user created" do
    assert User.count, 1
    assert @user.id, "Id bigger is 0"
    assert User.all[0], @user
  end

  test "should not create new user without username, email and encrypted_password" do
    user = User.new
    assert !user.save, "Saved the user without username, email and encrypted_password"
  end 

  test "should not create new user without email and encrypted_password" do
    user = User.new(username: "dummy")
    assert !user.save, "Saved the user without  email and encrypted_password"
  end  

  test "should not create new user without encrypted_password" do
    user = User.new(username: "dummy", email: "dummy@mail.org")
    assert !user.save, "Saved the user without encrypted_password"
  end 

end
