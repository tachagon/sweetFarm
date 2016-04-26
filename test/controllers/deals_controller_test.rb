require 'test_helper'

class DealsControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @other_user = users(:nina)
    @deal_wait_1 = deals(:deal_wait_1)
    @deal_accepted_1 = deals(:deal_accepted_1)
    @deal_paid_1 = deals(:deal_paid_1)
    @deal_shipped_1 = deals(:deal_shipped_1)
    @deal_reviewed_1 = deals(:deal_reviewed_1)
    @deal_completed_1 = deals(:deal_completed_1)
    @announcement = announcements(:announcement_sale_1)
    @user_announcement = announcements(:announcement_purchase_1)
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
    log_in_as(@admin)
    get :show, id: @deal_wait_1
    assert_template 'deals/show'
  end

  test "should redirect show when id invalid" do
    log_in_as(@user)
    get :show, id: -1
    assert_redirected_to deals_url
  end

  test "should redirect show when current user not owner deal" do
    log_in_as(@other_user)
    get :show, id: @deal_wait_1
    assert_redirected_to deals_url
  end

  test "should redirect show when current user not owner announcement" do
    deal = Deal.create!(amount: 10, price: 500, user:@admin)
    attraction = Attraction.create!(deal: deal, announcement: @user_announcement)
    log_in_as(@other_user)
    get :show, id: deal
    assert_redirected_to deals_url
  end

  test "should render show when current user owner announcement" do
    deal = Deal.create!(amount: 10, price: 500, user:@admin)
    attraction = Attraction.create!(deal: deal, announcement: @user_announcement)
    log_in_as(@user)
    get :show, id: deal
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

  test "should redirect create when not announcement_id params" do
    log_in_as(@user)
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post :create, deal: {amount: 10, price: 800}
      end
    end
    assert_redirected_to announcements_url
  end

  test "should render create when deal invalid" do
    log_in_as(@user)
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post :create, deal: {amount: -1, price: 'invalid'}, announcement_id: @announcement.id
      end
    end
    assert_not flash.empty?
    assert_template 'announcements/show'
  end

  test "should redirect create when announcement_id invalid" do
    log_in_as(@user)
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post :create, deal: {amount: @announcement.amount, price: 800}, announcement_id: -1
      end
    end
    assert_redirected_to announcements_url
  end

  test "should redirect create when announcement's user is current user" do
    log_in_as(@admin)
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post :create, deal: {amount: @announcement.amount, price: 800}, announcement_id: @announcement.id
      end
    end
    assert flash.empty?
    assert_redirected_to announcement_url(@announcement)
  end

  test "should redirect create when deal amount greater than announcement amount" do
    log_in_as(@user)
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post :create, deal: {amount: @announcement.amount + 0.1, price: 900}, announcement_id: @announcement.id
      end
    end
    assert flash.empty?
    assert_redirected_to announcement_url(@announcement)
  end

  test "should redirect create when success" do
    log_in_as(@user)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post :create, deal: {amount: @announcement.amount, price: 800}, announcement_id: @announcement.id
      end
    end
    assert_redirected_to announcement_url(@announcement)
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

  test "should redirect destroy when id invalid" do
    log_in_as(@user)
    delete :destroy, id: -1
    assert_redirected_to deals_url
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

  #=============================================================
  # test update_status_decline_accepted
  #=============================================================

  test "should redirect update_status_decline_accepted when not logged in" do
    patch :update_status_decline_accepted, deal_id: @deal_wait_1, deal: {status: 'decline'}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update_status_decline_accepted when deal_id invalid" do
    log_in_as(@admin)
    patch :update_status_decline_accepted, deal_id: -1, deal: {status: 'decline'}
    assert_redirected_to deals_url
  end

  #=============================================================
  # test update_status_paid
  #=============================================================

  test "should redirect update_status_paid when not logged in" do
    patch :update_status_paid, deal_id: @deal_accepted_1, deal: {status: "paid"}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update_status_paid when deal_id invalid" do
    log_in_as(@user)
    patch :update_status_paid, deal_id: -1, deal: {status: "paid"}
    assert_redirected_to deals_url
  end

end
