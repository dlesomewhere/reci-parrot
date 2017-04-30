require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it "is invalid if email is missing" do
    user.email = nil
    expect(user).to be_invalid
  end

  it "is invalid when email doesn't look like an email address" do
    user.email = "dave.example.test"
    expect(user).to be_invalid
  end

  it "is invalid when email is duplicated" do
    new_user = FactoryGirl.build(:user, email: user.email)
    expect(new_user).to be_invalid
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

    it "creates a user with the expected email" do
      expect(subject.email).to eq("john@companyname.com")
    end
  end

  describe "#full_name" do
    it "is first_name last_name" do
      expect(subject.full_name).to eq("#{subject.first_name} #{subject.last_name}")
    end
  end
end
