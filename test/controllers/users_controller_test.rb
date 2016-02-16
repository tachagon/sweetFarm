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

  test "should redirect edit when not logged in" do
    get :edit, id: @tatchagon
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @tatchagon, user: {name: @tatchagon.name, email: @tatchagon.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@pasin)
    get :edit, id: @tatchagon
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@pasin)
    patch :update, id: @tatchagon, user: {name: @tatchagon.name, email: @tatchagon.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should can't edit email" do
    c_email = @tatchagon.email
    email = "example@email.com"

    log_in_as(@tatchagon)
    patch :update, id: @tatchagon, user: {name: @tatchagon.name, email: email}
    @tatchagon.reload
    assert_not_equal(@tatchagon.email, email)
    assert_equal(@tatchagon.email, c_email)
  end

  test "should be edit name" do
    name = "Test Name"
    log_in_as @tatchagon
    patch :update, id: @tatchagon, user: {name: name, email: @tatchagon.email}
    @tatchagon.reload
    assert_equal(name, @tatchagon.name)
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@pasin)
    assert_not @pasin.admin?
    patch :update, id: @pasin, user:{
      password: '123456',
      password_confirmation: '123456',
      admin: true
    }
    assert_not @pasin.admin?
  end

end
