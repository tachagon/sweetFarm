require 'test_helper'

class DealsControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @deal_wait_1 = deals(:deal_wait_1)
    @deal_accepted_1 = deals(:deal_accepted_1)
    @deal_paid_1 = deals(:deal_paid_1)
    @deal_shipped_1 = deals(:deal_shipped_1)
    @deal_reviewed_1 = deals(:deal_reviewed_1)
    @deal_completed_1 = deals(:deal_completed_1)
  end

  #=============================================================
  # test index
  #=============================================================

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render index when logged in" do
    log_in_as(@user)
    get :index
    assert_template 'deals/index'
  end

  #=============================================================
  # test show
  #=============================================================

  test "should redirect show when not logged in" do
    get :show, id: @deal_wait_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render show when logged in" do
    log_in_as(@user)
    get :show, id: @deal_wait_1
    assert_template 'deals/show'
  end

  #=============================================================
  # test create
  #=============================================================

  test "should redirect create when not logged in" do
    post :create, deal: {
      amount: 10,
      price: 800
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  #=============================================================
  # test destroy
  #=============================================================

  test "should redirect destroy when not logged in" do
    delete :destroy, id: @deal_wait_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in as admin" do
    log_in_as(@user)
    delete :destroy, id: @deal_wait_1
    assert_redirected_to root_url
  end

  test "should redirect destroy when success" do
    log_in_as(@admin)
    assert_difference "Deal.count", -1 do
      delete :destroy, id: @deal_wait_1
    end
    assert_redirected_to admin_all_deals_url

    assert_difference "Deal.count", -1 do
      delete :destroy, id: @deal_completed_1
    end
    assert_redirected_to admin_all_deals_url
  end

end
