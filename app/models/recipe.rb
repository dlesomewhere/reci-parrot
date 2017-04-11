class Recipe < ApplicationRecord
  has_many :recipe_book_pages
  has_many :users, through: :recipe_book_pages

  validates :name, :url, presence: true
end
