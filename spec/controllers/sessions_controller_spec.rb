require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before :each do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    request.env["omniauth.params"] = { }
  end

  describe "POST #login_attempt" do
    let!(:existing_user) { FactoryGirl.create(:user, password: "password", password_confirmation: "password") }

    context "when the provided email and password match a user" do
      before :each do
        post :login_attempt, params: { email: existing_user.email, password: "password" }
      end

      it "redirects to the recipes index" do
        expect(response).to redirect_to(shares_path)
      end

      it "sets the user_id in the session" do
        expect(session[:user_id]).to eq(existing_user.id)
      end
    end

    context "when the provided email and password don't match a user" do
      it "redirects to the login_path" do
        post :login_attempt, params: { email: existing_user.email, password: "123456" }
        expect(response).to redirect_to(login_path)
      end
    end
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
      expect(subject).to redirect_to(shares_path)
    end

    context "when the share token cookie is set" do
      let!(:share) { FactoryGirl.create(:share) }

      before :each do
        cookies[:share_token] = share.token
      end

      it "creates a new user with the shared recipe" do
        expect {
          get :create, params: { share_token: share.token }
        }.to change { User.count }.from(1).to(2)

        expect(User.last.received_recipes).to match_array(share.recipe)
      end

      it "updates the share with the newly created user" do
        expect(share.recipient).to_not be_present
        get :create, params: { share_token: share.token }
        expect(share.reload.recipient).to eq(User.last)
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
