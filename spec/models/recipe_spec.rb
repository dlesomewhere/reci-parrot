require "rails_helper"

RSpec.describe Recipe, type: :model do
  let(:recipe) { FactoryGirl.build(:recipe) }

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
end
