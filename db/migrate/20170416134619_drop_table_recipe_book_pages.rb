class DropTableRecipeBookPages < ActiveRecord::Migration[5.0]
  def change
    drop_table :recipe_book_pages
  end
end
