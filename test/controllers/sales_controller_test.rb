require 'test_helper'

class SalesControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @banmai = districts(:banmai)
    @sale_1 = sales(:sale_1)
    @sale_2 = sales(:sale_2)
  end

  test "should redirect index when not logged in" do
    get :index, user_id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when not logged in" do
    get :show, user_id: @admin, id: @sale_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in" do
    get :new, user_id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when logged in as wrong user" do
    log_in_as(@user)
    get :new, user_id: @admin
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    post :create, user_id: @admin, sale: {}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when logged in as wrong user" do
    log_in_as(@user)
    post :create, user_id: @admin, sale: {}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create when successful" do
    log_in_as(@user)
    assert_difference "Sale.count", 1 do
      post :create, user_id: @user, sale: {amount: 10, price: 900, district_id: @banmai.id}
    end
    assert_not flash.empty?
    assert_redirected_to user_sales_url(@user)
  end

  test "should redirect edit when not logged in" do
    get :edit, user_id: @admin, id: @sale_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user)
    get :edit, user_id: @admin, id: @sale_1
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, user_id: @admin, id: @sale_1, sale: {}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user)
    patch :update, user_id: @admin, id: @sale_1, sale: {}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when user update sale of other user" do
    log_in_as(@user)
    sale = @admin.sales.first
    old_amount = sale.amount
    old_price = sale.price

    # update sale of other user
    assert_no_difference "Sale.count" do
      patch :update, user_id: @user, id: sale, sale: {
        amount: old_amount + 500,
        price: old_price + 599,
        district_id: sale.district_id
      }
    end

    sale.reload
    assert_equal(old_amount, sale.amount)
    assert_equal(old_price, sale.price)

  end

  test "should redirect update when successful" do
    log_in_as(@user)

    sale = @user.sales.build(
      amount: 20,
      price: 800,
      district_id: @banmai.id
      )
    sale.save!
    # check before updated sale
    assert_equal(sale.amount, 20)
    assert_equal(sale.price, 800)

    # update sale
    assert_no_difference "Sale.count" do
      patch :update, user_id: @user, id: sale, sale: {amount: 30, price: 900, district_id: @banmai.id}
    end

    # check after updated sale
    sale.reload
    assert_equal(sale.amount, 30)
    assert_equal(sale.price, 900)
  end

  test "should redirect destroy when not logged in" do
    delete :destroy, user_id: @admin, id: @sale_1
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in as admin" do
    log_in_as(@user)
    delete :destroy, user_id: @admin, id: @sale_1
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when success" do
    log_in_as(@admin)
    num_sales = @admin.sales.count

    delete :destroy, user_id: @admin, id: @sale_1
    assert_not flash.empty?
    assert_redirected_to admin_all_sales_url
    assert_equal(@admin.sales.count, num_sales - 1)

    delete :destroy, user_id: @admin, id: @sale_2
    assert_not flash.empty?
    assert_redirected_to admin_all_sales_url
    assert_equal(@admin.sales.count, num_sales - 2)

  end

end
