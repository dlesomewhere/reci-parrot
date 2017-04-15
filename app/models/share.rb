class Share < ApplicationRecord
  belongs_to :recipe
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true

  validates :recipient_email, presence: true

  before_create :generate_token

  def generate_token
     self.token = Digest::SHA1.hexdigest(
       [self.recipe_id, self.sender_id, Time.now].join
     )
  end
end
