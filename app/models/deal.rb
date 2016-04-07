class Deal < ActiveRecord::Base
  after_initialize :set_default_expire, if: :new_record?
  after_initialize :set_default_status, if: :new_record?

  belongs_to :user

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :expire, presence: true
  validates :user, presence: true
  def self.all_status ; %w[wait accepted paid shipped reviewed completed] ; end
  validates :status, presence: true, inclusion: {in: Deal.all_status}

  def set_default_expire ; self.expire ||= Time.now + 3.days ; end
  def set_default_status ; self.status ||= 'wait' ; end
end
