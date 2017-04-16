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

  describe "when saving" do
    it "the token is set" do
      expect { share.save }.to change { share.token }.from(nil).to be_present
    end
  end
end
