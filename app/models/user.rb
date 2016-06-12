class User < ActiveRecord::Base
  after_initialize :set_default_role, if: :new_record?

  has_many :single_sign_ons, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :deals, dependent: :destroy

  has_many :active_reviews, class_name: "Review", foreign_key: "reviewer_id", dependent: :destroy
  has_many :passive_reviews, class_name: "Review", foreign_key: "reviewed_id", dependent: :destroy
  has_many :reviewing, through: :active_reviews, source: :reviewed
  has_many :reviewers, through: :passive_reviews, source: :reviewer

  has_many :messages, dependent: :destroy

  attr_accessor :remember_token

  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def self.all_role ; %w[user cane_planter head_cane_planter factory] ; end
  validates :role, presence: true, inclusion: {in: User.all_role}, allow_nil: true

  mount_uploader :picture, PictureUploader
  validate :picture_size

  def set_default_role
    self.role ||= 'user'
  end

  def self.create_with_omniauth(auth)
    User.create!(
      name: auth["info"]["name"],
      email: auth["info"]["email"],
      password: "password",
      password_confirmation: "password"
    )
  end

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
      SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for user in persistent sessions.
  def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
      update_attribute(:remember_digest, nil)
  end

  # Review a user
  def review(other_user, deal, rating, comment)
    active_reviews.create(
      reviewed: other_user,
      deal: deal,
      rating: rating,
      comment: comment
    )
  end

  # Returns true if the current user is reviewing the other user
  def reviewing?(other_user)
    reviewing.include?(other_user)
  end

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, 'ขนาดภาพต้องไม่เกิน 5 MB')
      end
    end

end
