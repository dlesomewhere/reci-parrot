class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :url
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
  end
end
