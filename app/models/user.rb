class User < ApplicationRecord
  validates :uid, :provider, :email, presence: true
  validates :uid, uniqueness: { scope: :provider }
  validates :email, uniqueness: true

  has_many :recipe_book_pages
  has_many :recipes, through: :recipe_book_pages

  has_many :sent_shares, foreign_key: :sender_id, class_name: "Share"
  has_many :received_shares, foreign_key: :recipient_id, class_name: "Share"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
