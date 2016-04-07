require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase

  def setup
    @user = users(:tatchagon)
    @district = districts(:banmai)

    @announcement_sale = Announcement.new(
        amount: 50,
        price: 1000,
        role: 'sale',
        user: @user,
        district_id: @district.id
      )

    @announcement_purchase = Announcement.new(
        amount: 50,
        price: 1000,
        role: 'purchase',
        user: @user,
        district_id: @district.id
      )
  end

  test "should be valid" do
    assert @announcement_sale.valid?
    assert @announcement_purchase.valid?
  end

  # ==========================================================
  # test amount attribute
  # ==========================================================

  test "amount should be present" do
    @announcement_sale.amount = nil
    assert_not @announcement_sale.valid?
  end

  test "amount should be greater than 0" do
    @announcement_sale.amount = -1.0
    assert_not @announcement_sale.valid?

    @announcement_sale.amount = 0
    assert_not @announcement_sale.valid?

    @announcement_sale.amount = 0.1
    assert @announcement_sale.valid?
  end

  # ==========================================================
  # test price attribute
  # ==========================================================

  test "price should be present" do
    @announcement_sale.price = nil
    assert_not @announcement_sale.valid?
  end

  test "price should be greater than 0" do
    @announcement_sale.price = -1
    assert_not @announcement_sale.valid?

    @announcement_sale.price = 0
    assert_not @announcement_sale.valid?

    @announcement_sale.price = 0.1
    assert @announcement_sale.valid?
  end

  # ==========================================================
  # test role attribute
  # ==========================================================

  test "role should be present" do
    @announcement_sale.role = ''
    assert_not @announcement_sale.valid?
  end

  test "role should be sale or purchase" do
    @announcement_sale.role = 'invalid'
    assert_not @announcement_sale.valid?

    @announcement_sale.role = 'purchase'
    assert @announcement_sale.valid?

    @announcement_sale.role = 'sale'
    assert @announcement_sale.valid?
  end

  # ==========================================================
  # test expire attribute
  # ==========================================================

  test "expire should be present" do
    @announcement_sale.expire = nil
    assert_not @announcement_sale.valid?
  end

  test "expire should be default is next 7 days" do
    next_7_day = Time.now + 7.days
    @announcement_sale.save
    assert_equal(next_7_day.day, @announcement_sale.expire.day)
    assert_equal(next_7_day.month, @announcement_sale.expire.month)
    assert_equal(next_7_day.year, @announcement_sale.expire.year)
    assert_equal(next_7_day.hour, @announcement_sale.expire.hour)
    assert_equal(next_7_day.min, @announcement_sale.expire.min)
  end

  # ==========================================================
  # test show attribute
  # ==========================================================

  test "show should be present" do
    @announcement_sale.show = nil
    assert_not @announcement_sale.valid?
  end

  test "show should be default is true" do
    @announcement_sale.save
    assert_equal(@announcement_sale.show, true)
  end

  # ==========================================================
  # test user attribute
  # ==========================================================

  test "user should be present" do
    @announcement_sale.user = nil
    assert_not @announcement_sale.valid?
  end

  # ==========================================================
  # test district attribute
  # ==========================================================

  test "district should be present" do
    @announcement_sale.district = nil
    assert_not @announcement_sale.valid?
  end

end
