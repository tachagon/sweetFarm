require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @admin, user: {name: @admin.name, email: @admin.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user)
    get :edit, id: @admin
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch :update, id: @admin, user: {name: @admin.name, email: @admin.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should can't edit email" do
    c_email = @admin.email
    email = "example@email.com"

    log_in_as(@admin)
    patch :update, id: @admin, user: {name: @admin.name, email: email}
    @admin.reload
    assert_not_equal(@admin.email, email)
    assert_equal(@admin.email, c_email)
  end

  test "should be edit name" do
    name = "Test Name"
    log_in_as @admin
    patch :update, id: @admin, user: {name: name, email: @admin.email}
    @admin.reload
    assert_equal(name, @admin.name)
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user)
    assert_not @user.admin?
    patch :update, id: @user, user:{
      password: '123456',
      password_confirmation: '123456',
      admin: true
    }
    assert_not @user.admin?
  end

  test "should not allow the role attribute to be edited by user role" do
    log_in_as(@user)
    assert_not @user.admin?

    patch :update_role, user_id: @user, role: 'cane_planter'
    @user.reload
    assert_not_equal(@user.role, 'cane_planter')
  end

  test "should allow the role attribute to be edited by admin" do
    log_in_as(@admin)
    assert @admin.admin?

    patch :update_role, user_id: @user, role: 'cane_planter'
    @user.reload
    assert_equal(@user.role, 'cane_planter')

    patch :update_role, user_id: @user, role: 'head_cane_planter'
    @user.reload
    assert_equal(@user.role, 'head_cane_planter')
  end

end
