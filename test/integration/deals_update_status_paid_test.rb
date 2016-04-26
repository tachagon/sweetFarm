require 'test_helper'

class DealsUpdateStatusPaidTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:pasin)
    @other_user = users(:nina)
    @admin = users(:tatchagon)

    @deal_wait = deals(:deal_wait_1)
    @deal_purchase = deals(:deal_accepted_1)
    @deal_sale = deals(:deal_accepted_2)
  end

  test "should update deal status when role's announcement is sale" do
    log_in_as(@admin)
    patch deal_update_status_paid_path(deal_id: @deal_purchase, deal: {status: "paid"})
    @deal_purchase.reload
    assert_equal(@deal_purchase.status, "paid")
    assert_redirected_to deal_path(@deal_purchase)
  end

  test "should update deal status when role's announcement is purchase" do
    log_in_as(@user)
    patch deal_update_status_paid_path(deal_id: @deal_sale, deal:{status: "paid"})
    @deal_sale.reload
    assert_equal(@deal_sale.status, "paid")
    assert_redirected_to deal_path(@deal_sale)
  end

  test "should not update deal status when logged in user invalid" do
    log_in_as(@user)
    patch deal_update_status_paid_path(deal_id: @deal_purchase, deal: {status: "paid"})
    @deal_purchase.reload
    assert_not_equal(@deal_purchase.status, "paid")
    assert_equal(@deal_purchase.status, "accepted")
    assert_redirected_to deals_path

    delete logout_path

    log_in_as(@admin)
    patch deal_update_status_paid_path(deal_id: @deal_sale, deal:{status: "paid"})
    @deal_sale.reload
    assert_not_equal(@deal_sale.status, "paid")
    assert_equal(@deal_sale.status, "accepted")
    assert_redirected_to deals_path
  end

  test "should not update deal status when status data is invalid" do
    log_in_as(@admin)
    patch deal_update_status_paid_path(deal_id: @deal_purchase, deal: {status: "invalid"})
    @deal_purchase.reload
    assert_not_equal(@deal_purchase.status, "paid")
    assert_equal(@deal_purchase.status, "accepted")
    assert_redirected_to deals_path
  end

end
