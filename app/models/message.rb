class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal

  validates :body, presence: true

  scope :recent, -> {order('created_at DESC')}
end
