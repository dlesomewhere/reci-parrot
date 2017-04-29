class Authorization < ApplicationRecord
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  belongs_to :user

  def self.from_omniauth(auth, user=nil)
    user ||= User.from_omniauth(auth)

    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |auth|
      auth.user = user
      auth.save!
    end
  end
end
