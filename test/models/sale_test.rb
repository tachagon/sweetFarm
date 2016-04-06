require 'test_helper'

class SaleTest < ActiveSupport::TestCase

  def setup
    @user = users(:tatchagon)
    # @sale_status = sale_statuses(:active)
    @district = districts(:banmai)

    @sale = Sale.new(
        amount: 50,
        price: 1000,
        district: @district,
        user: @user
        # sale_status: @sale_status
      )
  end

  test "should be valid" do
    assert @sale.valid?
  end

  test "amount should be present" do
    @sale.amount = nil
    assert_not @sale.valid?
  end

  test "amount should be greater than 0" do
    @sale.amount = -1.0
    assert_not @sale.valid?

    @sale.amount = 0
    assert_not @sale.valid?

    @sale.amount = 0.1
    assert @sale.valid?
  end

  test "price should be present" do
    @sale.price = nil
    assert_not @sale.valid?
  end

  test "price should be greater than 0" do
    @sale.price = -1
    assert_not @sale.valid?

    @sale.price = 0
    assert_not @sale.valid?

    @sale.price = 0.1
    assert @sale.valid?
  end

  test "expire should be present" do
    @sale.expire = nil
    assert_not @sale.valid?
  end

  test "expire should be default is next 7 days" do
    next_7_day = Time.now + 7.days
    @sale.save
    assert_equal(next_7_day.day, @sale.expire.day)
    assert_equal(next_7_day.month, @sale.expire.month)
    assert_equal(next_7_day.year, @sale.expire.year)
    assert_equal(next_7_day.hour, @sale.expire.hour)
    assert_equal(next_7_day.min, @sale.expire.min)
  end

  test "sale status should be default is active" do
    @sale.save
    assert_equal(@sale.sale_status.name, 'active')
  end

  test "sale status should be present" do
    @sale.sale_status = nil
    assert_not @sale.valid?
  end

  test "show should be present" do
    @sale.show = nil
    assert_not @sale.valid?
  end

  test "show should be default is true" do
    @sale.save
    assert_equal(@sale.show, true)
  end

end
