class Announcement < ActiveRecord::Base
  after_initialize :set_default_expire, if: :new_record?

  belongs_to :user
  belongs_to :district
  has_many :attractions, dependent: :destroy
  has_many :deals, through: :attractions

  mount_uploader :cane_picture, CanePictureUploader
  validate :cane_picture_size

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :price, presence: true, numericality: {greater_than: 0}
  def self.all_role ; %w[sale purchase] ; end
  validates :role, presence: true, inclusion: {in: Announcement.all_role}
  validates :expire, presence: true
  validates :show, presence: true
  validates :user, presence: true
  validates :district_id, presence: true

  def set_default_expire ; self.expire ||= Time.now + 7.days ; end

  scope :not_expired, -> {where("expire >= NOW() - INTERVAL 7 HOUR")}
  scope :show, -> {where(show: true)}
  scope :recent, -> {order('updated_at DESC')}
  scope :auction_recent, -> {order('expire ASC')}
  scope :user, -> (user_id){where(user: user_id)}
  scope :other_user, -> (user_id){where("user_id != #{user_id}")}
  scope :role, -> (role){where(role: role)}

  private
    def cane_picture_size
      if cane_picture.size > 5.megabytes
        errors.add(:cane_picture, 'ขนาดภาพต้องไม่เกิน 5 MB')
      end
    end

end
