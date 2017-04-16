class Recipe < ApplicationRecord
  has_many :shares
  has_many :users, through: :shares, source: :recipient

  validates :name, :url, presence: true
end
