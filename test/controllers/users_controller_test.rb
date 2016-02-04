require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @tatchagon = users(:tatchagon)
    @pasin = users(:pasin)
  end

  test "should redirect index when not logged in" do
    #
  end

  test "should get new" do
    get :new
    assert_response :success
  end

end
