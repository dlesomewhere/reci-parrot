require "rails_helper"

RSpec.describe Recipe, type: :model do
  let(:recipe) { FactoryGirl.create(:recipe) }

  it "is valid with default factory attributes" do
    expect(recipe).to be_valid
  end

  it "is invalid when url is missing" do
    recipe.url = nil
    expect(recipe).to be_invalid
  end

  it "is invalid when name is missing" do
    recipe.name = nil
    expect(recipe).to be_invalid
  end

  describe "#editable?" do
    it "is true when the recipe hasn't been shared with other users yet" do
      recipe.shares << FactoryGirl.create(:share, :with_self)
      expect(recipe.editable?).to eq(true)
    end

    it "is false when the recipe has been shared with other users" do
      recipe.shares << FactoryGirl.create(:share, :with_existing_user)
      expect(recipe.editable?).to eq(false)
    end
  end

  describe "locked?" do
    it "is false when the recipe hasn't been shared with other users yet" do
      recipe.shares << FactoryGirl.create(:share, :with_self)
      expect(recipe.locked?).to eq(false)
    end

    it "is true when the recipe has been shared with other users" do
      recipe.shares << FactoryGirl.create(:share, :with_existing_user)
      expect(recipe.locked?).to eq(true)
    end
  end
end
