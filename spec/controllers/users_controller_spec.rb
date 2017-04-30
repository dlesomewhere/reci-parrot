require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:user_with_password) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_user) }

  describe "GET #new" do
    it "assigns a new user as @user" do
      get :new, params: {}
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "assigns newly created user as @user" do
        post :create, params: { user: valid_attributes }
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the recipes index" do
        post :create, params: { user: valid_attributes }
        expect(subject).to redirect_to(shares_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders the 'new' template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  context "when request has a share token" do
    let!(:share) { FactoryGirl.create(:share) }

    it "creates a new user with the shared recipe" do
      expect {
        get :create, params: { user: valid_attributes, share_token: share.token }
      }.to change { User.count }.from(1).to(2)

      expect(User.last.received_recipes).to match_array(share.recipe)
    end

    it "updates the share with the newly created user" do
      expect(share.recipient).to_not be_present
      get :create, params: { user: valid_attributes, share_token: share.token }
      expect(share.reload.recipient).to eq(User.last)
    end
  end
end
