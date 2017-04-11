require "rails_helper"

RSpec.describe RecipeBookPage, type: :model do
  let(:recipe_book_page) { FactoryGirl.build(:recipe_book_page) }

  it "is valid with default factory attributes" do
    expect(recipe_book_page).to be_valid
  end

  it "is invalid if user is missing" do
    recipe_book_page.user = nil
    expect(recipe_book_page).to be_invalid
  end

  it "is invalid if recipe is missing" do
    recipe_book_page.recipe = nil
    expect(recipe_book_page).to be_invalid
  end
end
