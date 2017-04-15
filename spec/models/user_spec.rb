require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it "is invalid if email is missing" do
    user.email = nil
    expect(user).to be_invalid
  end

  it "is invalid if uid is missing" do
    user.uid = nil
    expect(user).to be_invalid
  end

  it "is invalid if provider is missing" do
    user.provider = nil
    expect(user).to be_invalid
  end

  it "is invalid if uid is duplicated with the same provider" do
    new_user = FactoryGirl.build(:user, uid: user.uid, provider: user.provider)
    expect(new_user).to be_invalid
  end

  it "is valid if uid is duplicated with different providers" do
    new_user = FactoryGirl.build(:user, uid: user.uid, provider: "other provider")
    expect(new_user).to be_valid
  end

  describe ".from_omniauth" do
    subject { User.from_omniauth(OmniAuth.config.mock_auth[:google_oauth2]) }

    it "creates a new user" do
      expect { subject }.to change { User.count }.from(0).to(1)
    end

    it "creates one user when called twice with the same parameters" do
      expect { subject }.to change { User.count }.from(0).to(1)
      expect { subject }.to_not change { User.count }
    end

    it "creates a user with the expected first_name" do
      expect(subject.first_name).to eq("John")
    end

    it "creates a user with the expected last_name" do
      expect(subject.last_name).to eq("Doe")
    end

    it "creates a user with the expected provider" do
      expect(subject.provider).to eq("google_oauth2")
    end

    it "creates a user with the expected uid" do
      expect(subject.uid).to eq("123456789")
    end

    it "creates a user with the expected oauth_token" do
      expect(subject.oauth_token).to eq("token")
    end

    it "creates a user with the expected oauth_expires_at" do
      expect(subject.oauth_expires_at).to eq(Time.at(1354920555))
    end
  end

  describe "#full_name" do
    it "is first_name last_name" do
      expect(subject.full_name).to eq("#{subject.first_name} #{subject.last_name}")
    end
  end
end
