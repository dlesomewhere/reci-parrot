class CreateShares < ActiveRecord::Migration[5.0]
  def change
    create_table :shares do |t|
      t.belongs_to :recipe, null: false
      t.belongs_to :sender, null: false
      t.string :recipient_email, null: false
      t.string :token, null: false
      t.belongs_to :recipient
      t.timestamps
    end
  end
end
