class Review < ActiveRecord::Base
  belongs_to :deal#, counter_cache: true
  # validates_associated :deal

  belongs_to :reviewer, class_name: "User"
  belongs_to :reviewed, class_name: "User"

  validates :reviewer_id, presence: true
  validates :reviewed_id, presence: true

  validates :rating, presence: true, numericality: {only_integer: true ,greater_than: 0, less_than_or_equal_to: 5}
  validates :comment, presence: true

  scope :recent, -> {order('created_at DESC')}

end
