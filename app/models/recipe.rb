class Recipe < ApplicationRecord
  has_many :shares
  has_many :users, through: :shares, source: :recipient

  validates :name, :url, presence: true

  def editable?
    !locked?
  end

  def locked?
    shares.merge(Share.with_other_user).any?
  end
end
