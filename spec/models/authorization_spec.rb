require "rails_helper"

RSpec.describe Authorization, type: :model do
  let(:authorization) { FactoryGirl.create(:authorization) }

  it "is invalid without a user" do
    authorization.user = nil
    expect(authorization).to be_invalid
  end

  it "is invalid if uid is missing" do
    authorization.uid = nil
    expect(authorization).to be_invalid
  end

  it "is invalid if provider is missing" do
    authorization.provider = nil
    expect(authorization).to be_invalid
  end

  it "is invalid if uid is duplicated with the same provider" do
    new_authorization = FactoryGirl.build(:authorization, uid: authorization.uid, provider: authorization.provider)
    expect(new_authorization).to be_invalid
  end

  it "is valid if uid is duplicated with different providers" do
    new_authorization = FactoryGirl.build(:authorization, uid: authorization.uid, provider: "other provider")
    expect(new_authorization).to be_valid
  end

  describe ".from_omniauth" do
    subject { Authorization.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2]) }

    it "creates a new authorization" do
      expect { subject }.to change { Authorization.count }.from(0).to(1)
    end

    it "creates one authorization when called twice with the same parameters" do
      expect { subject }.to change { Authorization.count }.from(0).to(1)
      expect { subject }.to_not change { Authorization.count }
    end

    it "creates an authorization with the expected provider" do
      expect(subject.provider).to eq("google_oauth2")
    end

    it "creates an authorization with the expected uid" do
      expect(subject.uid).to eq("123456789")
    end
  end
end
