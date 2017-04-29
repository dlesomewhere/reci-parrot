class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end
  end
end
