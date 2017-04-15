require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before :each do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe "#create" do
    subject { get :create }

    it "creates a user when one doesn't already exist" do
      expect { subject }.to change { User.count }.from(0).to(1)
    end

    it "sets the user_id in the session" do
      expect { subject }.to change { session[:user_id] }.from(nil).to be_present
    end

    it "redirects to the recipes index" do
      expect(subject).to redirect_to(recipes_path)
    end
  end

  context "when request has a share token" do
    describe "#create" do
      it "creates a new user with the shared recipe" do
        share = FactoryGirl.create(:share)

        expect {
          get :create, params: { share_token: share.token }
        }.to change { User.count }.from(1).to(2)

        expect(User.last.recipes.first).to eq(share.recipe)
      end
    end
  end

  describe "#destroy" do
    before :each do
      get :create
    end

    subject { get :destroy }

    it "resets the session" do
      expect(session[:user_id]).to be_present
      expect { subject }.to change { session[:user_id] }.to be_nil
    end

    it "redirects to the root_path" do
      expect(subject).to redirect_to(root_path)
    end
  end
end
