require 'test_helper'

class PostTest < ActiveSupport::TestCase

  fixtures :posts
 
  def setup 
    @post = posts(:hello)
  end

  test "should have one post" do
    assert_equal 1, Post.count
  end

end
