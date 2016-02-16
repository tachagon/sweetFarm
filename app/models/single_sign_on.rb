class SingleSignOn < ActiveRecord::Base
  belongs_to :user

  def self.create_with_omniauth(auth)
    SingleSignOn.create!(
      provider: auth["provider"],
      uid: auth["uid"]
    )
  end
end
