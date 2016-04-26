require 'test_helper'

class DealTest < ActiveSupport::TestCase

  def setup
    @user = users(:tatchagon)
    @deal = Deal.new(
        amount: 50,
        price: 1000,
        user: @user
      )
  end

  test "should be valid" do
    assert @deal.valid?
  end

  # ==========================================================
  # test amount attribute
  # ==========================================================

  test "amount should be present" do
    @deal.amount = nil
    assert_not @deal.valid?
  end

  test "amount should be greater than 0" do
    @deal.amount = -1.0
    assert_not @deal.valid?

    @deal.amount = 0
    assert_not @deal.valid?

    @deal.amount = 0.1
    assert @deal.valid?
  end

  # ==========================================================
  # test price attribute
  # ==========================================================

  test "price should be present" do
    @deal.price = nil
    assert_not @deal.valid?
  end

  test "price should be greater than 0" do
    @deal.price = -1
    assert_not @deal.valid?

    @deal.price = 0
    assert_not @deal.valid?

    @deal.price = 0.1
    assert @deal.valid?
  end

  # ==========================================================
  # test expire attribute
  # ==========================================================

  test "expire should be present" do
    @deal.expire = nil
    assert_not @deal.valid?
  end

  test "expire should be default is next 3 days" do
    next_3_day = Time.now + 3.days
    @deal.save
    assert_equal(next_3_day.day, @deal.expire.day)
    assert_equal(next_3_day.month, @deal.expire.month)
    assert_equal(next_3_day.year, @deal.expire.year)
    assert_equal(next_3_day.hour, @deal.expire.hour)
    assert_equal(next_3_day.min, @deal.expire.min)
  end

  # ==========================================================
  # test user attribute
  # ==========================================================

  test "user should be present" do
    @deal.user = nil
    assert_not @deal.valid?
  end

  # ==========================================================
  # test status attribute
  # ==========================================================

  test "status should be present" do
    @deal.status = ''
    assert_not @deal.valid?
  end

  test "status should be wait, accepted, paid, shipped, reviewed or completed" do
    @deal.status = 'invalid'
    assert_not @deal.valid?

    @deal.status = 'wait'
    assert @deal.valid?

    @deal.status = 'decline'
    assert @deal.valid?

    @deal.status = 'accepted'
    assert @deal.valid?

    @deal.status = 'paid'
    assert @deal.valid?

    @deal.status = 'shipped'
    assert @deal.valid?

    @deal.status = 'reviewed'
    assert @deal.valid?

    @deal.status = 'completed'
    assert @deal.valid?

  end

end
