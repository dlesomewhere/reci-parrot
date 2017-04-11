class CreateRecipeBookPages < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_book_pages do |t|
      t.belongs_to :recipe, null: false
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
