require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  def setup
    @deal = deals(:deal_shipped_1)
    @review = Review.new(
      reviewer_id: 1,
      reviewed_id: 2,
      deal: @deal,
      rating: 4,
      comment: "Very good")
  end

  test "should be valid" do
    assert @review.valid?
  end

  test "should require a reviewer_id" do
    @review.reviewer_id = nil
    assert_not @review.valid?
  end

  test "should require a reviewed_id" do
    @review.reviewed_id = nil
    assert_not @review.valid?
  end

  test "rating should be present" do
    @review.rating = nil
    assert_not @review.valid?
  end

  test "rating should be integer" do
    @review.rating = 1.2
    assert_not @review.valid?
  end

  test "rating should be greater than 0" do
    @review.rating = 0
    assert_not @review.valid?
    @review.rating = -1
    assert_not @review.valid?
    @review.rating = 1
    assert @review.valid?
  end

  test "rating should be less than or equal to 5" do
    @review.rating = 5
    assert @review.valid?
    @review.rating = 6
    assert_not @review.valid?
    @review.rating = 4
    assert @review.valid?
  end

  test "comment should be present" do
    @review.comment = ""
    assert_not @review.valid?
  end

end
