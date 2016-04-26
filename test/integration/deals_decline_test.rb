require 'test_helper'

class DealsDeclineTest < ActionDispatch::IntegrationTest

  def setup
      @admin = users(:tatchagon)
      @user = users(:pasin)
      @other_user = users(:nina)
  end

  test "deal decline user's announcement" do
    announcement = @user.announcements.first
    # simulate create new deal
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end

    delete logout_path

    # simulate decline deal
    deal = announcement.deals.last
    log_in_as(@user)
    get announcement_path(id: announcement)
    patch deal_update_status_decline_accepted_path(deal_id: deal, deal: {status: 'decline'})
    deal.reload
    assert_equal(deal.status, 'decline')
    assert_not flash.empty?
    assert_redirected_to deal_path(deal)
  end

  test "deal accepted user's announcement" do
    announcement = @user.announcements.first
    # simulate create new deal
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end

    delete logout_path

    # simulate accepted deal
    deal = announcement.deals.last
    log_in_as(@user)
    get announcement_path(id: announcement)
    patch deal_update_status_decline_accepted_path(deal_id: deal, deal: {status: 'accepted'})
    deal.reload
    assert_equal(deal.status, 'accepted')
    assert_not flash.empty?
    assert_redirected_to deal_path(deal)
  end

  test "deal decline not user's announcement" do
    announcement = @user.announcements.first
    # simulate create new deal
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end

    delete logout_path

    # simulate decline deal
    deal = announcement.deals.last
    log_in_as(@admin)
    get announcement_path(id: announcement)
    patch deal_update_status_decline_accepted_path(deal_id: deal, deal: {status: 'decline'})
    deal.reload
    assert_equal(deal.status, 'wait')
    assert_not_equal(deal.status, 'decline')
    assert_redirected_to root_path
  end

  test "deal decline with deal expired" do
    announcement = @user.announcements.first
    # simulate create new deal
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end

    delete logout_path

    # simulate decline deal
    deal = announcement.deals.last
    deal.expire = 1.days.ago
    deal.save!
    log_in_as(@user)
    get announcement_path(id: announcement)
    patch deal_update_status_decline_accepted_path(deal_id: deal, deal: {status: 'decline'})
    deal.reload
    assert_equal(deal.status, 'wait')
    assert_not_equal(deal.status, 'decline')
    assert_not flash.empty?
    assert_redirected_to deals_path
  end

  test "deal decline with deal status is't wait" do
    announcement = @user.announcements.first
    # simulate create new deal
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end

    delete logout_path

    # simulate decline deal
    deal = announcement.deals.last
    deal.status = 'paid'
    deal.save!
    log_in_as(@user)
    get announcement_path(id: announcement)
    patch deal_update_status_decline_accepted_path(deal_id: deal, deal: {status: 'decline'})
    deal.reload
    assert_equal(deal.status, 'paid')
    assert_not_equal(deal.status, 'decline')
    assert_not flash.empty?
    assert_redirected_to deals_path
  end

end
