require "rails_helper"

RSpec.describe Share, type: :model do
  let(:share) { FactoryGirl.build(:share) }

  it "is valid with valid attributes" do
    expect(share).to be_valid
  end

  it "is invalid recipient_email is missing" do
    share.recipient_email = nil
    expect(share).to be_invalid
  end

  it "is invalid when sender is missing" do
    share.sender = nil
    expect(share).to be_invalid
  end

  it "is invalid when recipe is missing" do
    share.recipe = nil
    expect(share).to be_invalid
  end

  it "is invalid when the same recipe has the same recipient_email" do
    share.save!
    new_share = FactoryGirl.build(:share, recipe: share.recipe, recipient_email: share.recipient_email)
    expect(new_share).to be_invalid
  end

  it "is invalid when the same recipe has the same recipient" do
    recipient = FactoryGirl.create(:user)
    share.update(recipient: recipient)
    new_share = FactoryGirl.build(:share, recipe: share.recipe, recipient: recipient)

    expect(new_share).to be_invalid
  end

  it "is valid when the same recipe has multiple unknown recipients" do
    share.update(recipient: nil)
    new_share = FactoryGirl.build(:share, recipe: share.recipe, recipient: nil)

    expect(new_share).to be_valid
  end

  describe "when saving" do
    it "the token is set" do
      expect { share.save }.to change { share.token }.from(nil).to be_present
    end
  end

  describe "#number_of_users_with_recipe" do
    it "is the number of distinct users that have access to the recipe" do
      share = FactoryGirl.create(:share, :with_self)
      FactoryGirl.create(:share, :with_existing_user, recipe: share.recipe)
      FactoryGirl.create(:share, recipe: share.recipe)

      expect(share.number_of_users_with_recipe).to eq(2)
    end
  end
end
