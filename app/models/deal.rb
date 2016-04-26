class Deal < ActiveRecord::Base
  after_initialize :set_default_expire, if: :new_record?
  after_initialize :set_default_status, if: :new_record?

  belongs_to :user
  has_many :attractions, dependent: :destroy
  has_many :announcements, through: :attractions

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :expire, presence: true
  validates :user, presence: true
  def self.all_status ; %w[wait accepted decline paid shipped reviewed completed] ; end
  validates :status, presence: true, inclusion: {in: Deal.all_status}

  def set_default_expire ; self.expire ||= Time.now + 3.days ; end
  def set_default_status ; self.status ||= 'wait' ; end

  scope :not_expired, -> {where('expire >= NOW()')}
  scope :user, -> (user_id){where(user: user_id)}
  scope :status, -> (status){where(status: status)}
  scope :recent, -> {order('updated_at DESC')}
  scope :best_price, -> {order('price DESC')}
  scope :best_amount, -> {order('amount DESC')}
end
