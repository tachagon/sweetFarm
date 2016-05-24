require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase

  def setup
    @admin = users(:tatchagon)
    @user = users(:pasin)
    @deal = deals(:deal_shipped_1)
  end

  test "should redirect create when not logged in" do
    post :create, reviewed_id: @user.id, deal_id: @deal.id, rating: 3, comment: "good"
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when success" do
    log_in_as(@admin)
    assert_difference "Review.count", 1 do
      post :create, reviewed_id: @user.id, deal_id: @deal.id, rating: 3, comment: "good"
    end
  end

end
