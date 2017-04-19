class Share < ApplicationRecord
  belongs_to :recipe
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true

  validates :recipient_email, presence: true
  validates :recipient_email, uniqueness: { scope: :recipe }
  validates :recipient, uniqueness: { scope: :recipe }, allow_nil: true

  before_create :generate_token

  scope :with_other_user, lambda { where("sender_id != recipient_id OR recipient_id IS NULL") }

  def number_of_users_with_recipe
    @number_of_users_with_recipe ||= User.joins(:received_shares).
      where(shares: { recipe_id: recipe.id }).count
  end

  def generate_token
     self.token = Digest::SHA1.hexdigest(
       [self.recipe_id, self.sender_id, Time.now].join
     )
  end
end
