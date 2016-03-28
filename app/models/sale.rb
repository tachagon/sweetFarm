class Sale < ActiveRecord::Base
  after_initialize :set_default_expire, if: :new_record?
  after_initialize :set_default_sale_status, if: :new_record?

  belongs_to :district
  belongs_to :user
  belongs_to :sale_status

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :district_id, presence: true
  validates :user, presence: true
  validates :expire, presence: true
  validates :sale_status, presence: true
  validates :show, presence: true

  def set_default_expire ; self.expire ||= Time.now + 7.days ; end
  def set_default_sale_status
    @sale_status = SaleStatus.find_by_name('active')
    self.sale_status = @sale_status
  end

end
