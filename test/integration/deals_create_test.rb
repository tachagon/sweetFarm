require 'test_helper'

class DealsCreateTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @other_user = users(:nina)
  end

  test "deal with invalid information" do
    announcement = @user.announcements.first
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_template 'announcements/show'
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post deals_path(announcement_id: announcement, deal: {amount: nil, price: -1})
      end
    end
    assert_redirected_to announcement_path(announcement)
    assert_not flash.empty?
  end

  test "deal with announcement expired" do
    announcement = @user.announcements.first
    announcement.expire = 1.days.ago
    announcement.save!
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_template 'announcements/show'
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end
    assert_redirected_to announcement_path(announcement)
  end

  test "deal with invalid user(owner announcement)" do
    announcement = @user.announcements.first
    log_in_as(@user)
    get announcement_path(id: announcement)
    assert_template 'announcements/show'
    assert_no_difference "Deal.count" do
      assert_no_difference "Attraction.count" do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end
    assert_redirected_to announcement_path(id: announcement)
  end

  test "deal with valid information" do
    announcement = @user.announcements.first
    log_in_as(@other_user)
    get announcement_path(id: announcement)
    assert_template 'announcements/show'
    assert_difference "Deal.count", 1 do
      assert_difference "Attraction.count", 1 do
        post deals_path(announcement_id: announcement, deal: {amount: 50, price: 900})
      end
    end
    assert_redirected_to announcement_path(id: announcement)
    assert_not flash.empty?
  end

end
