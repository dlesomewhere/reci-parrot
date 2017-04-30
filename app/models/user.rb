class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :email, uniqueness: true
  validates :email, email_format: true

  has_many :sent_shares, foreign_key: :sender_id, class_name: "Share"
  has_many :sent_recipes, through: :sent_shares, source: :recipe

  has_many :received_shares, foreign_key: :recipient_id, class_name: "Share"
  has_many :received_recipes, through: :received_shares, source: :recipe

  has_many :authorizations

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create(
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      password_digest: "NA",
    )
  end

  def full_name
    [first_name, last_name].join(" ")
  end
end
