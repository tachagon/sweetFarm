class Sale < ActiveRecord::Base
  after_initialize :set_default_expire, if: :new_record?

  belongs_to :district
  belongs_to :user
  belongs_to :sale_status

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :district_id, presence: true

  def set_default_expire ; self.expire ||= Time.now + 7.days ; end

end
