require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @banmai = districts(:banmai)
    @announcement_sale_1 = announcements(:announcement_sale_1)
    @announcement_purchase_1 = announcements(:announcement_purchase_1)
  end

  #=============================================================
  # test index
  #=============================================================

  test "should render index when not logged in" do
    get :index
    assert_template 'announcements/index'
  end

  test "should render index when logged in" do
    log_in_as(@user)
    get :index
    assert_template 'announcements/index'
  end

  #=============================================================
  # test show
  #=============================================================

  test "should redirect show when not logged in" do
    get :show, id: @announcement_sale_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render show when logged in" do
    log_in_as(@user)
    get :show, id: @announcement_sale_1
    assert_template 'announcements/show'
  end

  test "should redirect show when id invalid" do
    log_in_as(@user)
    get :show, id: -1
    assert_redirected_to announcements_url
  end

  #=============================================================
  # test new
  #=============================================================

  test "should redirect new when not logged in" do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not have role params" do
    log_in_as(@user)
    get :new
    assert_redirected_to announcements_url
  end

  test "should redirect new when logged in and invalid role params" do
    log_in_as(@user)
    get :new, role: 'invalid'
    assert_redirected_to announcements_url
  end

  test "should render new when logged in and valid role params" do
    log_in_as(@user)
    get :new, role: 'sale'
    assert_template 'announcements/new'

    get :new, role: 'purchase'
    assert_template 'announcements/new'
  end

  #=============================================================
  # test create
  #=============================================================

  test "should redirect create when not logged in" do
    post :create, announcement: {
      amount: 10,
      price: 800,
      role: 'sale',
      district_id: @banmai.id
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render create when not success" do
    log_in_as(@user)
    assert_no_difference "Announcement.count" do
      post :create, announcement: {
        amount: 0,
        price: 0,
        role: 'invalid',
        district_id: @banmai.id
      }
    end
    assert_template 'announcements/new'
  end

  test "should redirect create when success" do
    log_in_as(@user)
    amount = 550099
    price = 112233

    assert_difference "Announcement.count", 1 do
      post :create, announcement: {
        amount: amount,
        price: price,
        role: 'sale',
        district_id: @banmai.id
      }
    end

    new_announcement = @user.announcements.last
    assert_redirected_to announcement_url(new_announcement)

    assert_equal(new_announcement.amount, amount)
    assert_equal(new_announcement.price, price)
  end

  #=============================================================
  # test edit
  #=============================================================

  test "should redirect edit when not logged in" do
    get :edit, id: @announcement_sale_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render edit when logged in" do
    log_in_as(@admin)
    get :edit, id: @admin.announcements.first
    assert_template 'announcements/edit'
  end

  test "should redirect edit when edit announcement of other user" do
    log_in_as(@user)
    get :edit, id: @admin.announcements.first
    assert_redirected_to root_url
  end

  test "should redirect edit when id invalid" do
    log_in_as(@user)
    get :edit, id: -1
    assert_redirected_to announcements_url
  end

  #=============================================================
  # test update
  #=============================================================

  test "should redirect update when not logged in" do
    patch :update, id: @announcement_sale_1, announcement: {
      amount: 999111,
      price: 334455,
      role: 'sale',
      district_id: @banmai.id
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when update announcement of other user" do
    log_in_as(@user)
    assert_no_difference "Announcement.count" do
      patch :update, id: @admin.announcements.first, announcement: {
        amount: 999111,
        price: 334455,
        role: 'sale',
        district_id: @banmai.id
      }
    end
    assert_redirected_to root_url
  end

  test "should render update when not success" do
    log_in_as(@admin)
    assert_no_difference "Announcement.count" do
      patch :update, id: @admin.announcements.first, announcement: {
        amount: 0,
        price: 0,
        role: 'invalid',
        district_id: @banmai.id
      }
    end
    assert_template 'announcements/edit'
  end

  test "should redirect update when success" do
    log_in_as(@admin)
    @announcement = @admin.announcements.first
    amount = 555666
    price = 887766

    patch :update, id: @announcement, announcement: {
      amount: amount,
      price: price,
      role: 'sale',
      district_id: @banmai.id
    }

    next_week = Time.now + 7.days
    @announcement.reload
    assert_redirected_to announcement_url(@announcement)
    assert_equal(@announcement.amount, amount)
    assert_equal(@announcement.price, price)

    # check auto incretment expire 1 week
    assert_equal(@announcement.expire.day, next_week.day)
    assert_equal(@announcement.expire.month, next_week.month)
    assert_equal(@announcement.expire.year, next_week.year)
    assert_equal(@announcement.expire.hour, next_week.hour)
    assert_equal(@announcement.expire.min, next_week.min)
end

test "should redirect update when id invalid" do
  log_in_as(@user)
  assert_no_difference "Announcement.count" do
    patch :update, id: -1, announcement: {
      amount: 50,
      price: 800,
      role: 'sale',
      district_id: @banmai.id
    }
  end
  assert_redirected_to announcements_url
end

#=============================================================
# test destroy
#=============================================================

test "should redirect destroy when not logged in" do
  delete :destroy, id: @announcement_sale_1
  assert_not flash.empty?
  assert_redirected_to login_url
end

test "should redirect destroy when not logged in as admin" do
  log_in_as(@user)
  delete :destroy, id: @announcement_sale_1
  assert_redirected_to root_url
end

# test "should redirect destroy when success" do
#   log_in_as(@admin)
#   assert_difference "Announcement.count", -1 do
#     delete :destroy, id: @announcement_sale_1
#   end
#   assert_redirected_to admin_all_announcements_url

#   assert_difference "Announcement.count", -1 do
#     delete :destroy, id: @announcement_purchase_1
#   end
#   assert_redirected_to admin_all_announcements_url
# end

end
