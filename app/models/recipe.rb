class Recipe < ApplicationRecord
  belongs_to :user

  validates :user, :name, :url, presence: true
end
