require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:share) { FactoryGirl.create(:share, :with_existing_user) }
  let(:recipe) { share.recipe }
  let(:user) { share.recipient }

  let(:valid_session) { { user_id: user.id } }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_recipe) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:recipe) }

  let(:other_share) { FactoryGirl.create(:share, :with_existing_user) }
  let!(:other_recipe) { other_share.recipe }

  describe "GET #show" do
    it "assigns the requested recipe as @recipe" do
      get :show, params: {id: recipe.to_param}, session: valid_session
      expect(assigns(:recipe)).to eq(recipe)
    end

    it "assigns a new share as @share" do
      get :show, params: {id: recipe.to_param}, session: valid_session
      expect(assigns(:share)).to be_a_new(Share)
      expect(assigns(:share).recipe).to eq(recipe)
      expect(assigns(:share).sender).to eq(user)
    end

    it "assigns shares made by me to @my_shares" do
      FactoryGirl.create(:share, recipe: recipe)
      my_share = FactoryGirl.create(:share, sender: user, recipe: recipe)
      get :show, params: {id: recipe.to_param}, session: valid_session
      expect(assigns(:my_shares)).to match_array(my_share)
    end

    it "redirects to shares_path if recipe belongs to another user" do
      get :show, params: {id: other_recipe.to_param}, session: valid_session
      expect(response).to redirect_to(shares_path)
    end
  end

  describe "GET #new" do
    it "assigns a new recipe as @recipe" do
      get :new, params: {}, session: valid_session
      expect(assigns(:recipe)).to be_a_new(Recipe)
    end
  end

  describe "GET #edit" do
    it "assigns the requested recipe as @recipe" do
      get :edit, params: {id: recipe.to_param}, session: valid_session
      expect(assigns(:recipe)).to eq(recipe)
    end

    it "redirects to shares_path if recipe belongs to another user" do
      get :edit, params: {id: other_recipe.to_param}, session: valid_session
      expect(response).to redirect_to(shares_path)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Recipe" do
        expect {
          post :create, params: {recipe: valid_attributes}, session: valid_session
        }.to change(Recipe, :count).by(1)
      end

      it "assigns a newly created recipe as @recipe" do
        post :create, params: {recipe: valid_attributes}, session: valid_session
        expect(assigns(:recipe)).to be_a(Recipe)
        expect(assigns(:recipe)).to be_persisted
      end

      it "redirects to the created recipe" do
        post :create, params: {recipe: valid_attributes}, session: valid_session
        expect(response).to redirect_to(assigns(:recipe))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved recipe as @recipe" do
        post :create, params: {recipe: invalid_attributes}, session: valid_session
        expect(assigns(:recipe)).to be_a_new(Recipe)
      end

      it "re-renders the 'new' template" do
        post :create, params: {recipe: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { FactoryGirl.attributes_for(:recipe, name: "Fish!") }

      it "updates the requested recipe" do
        put :update, params: {id: recipe.to_param, recipe: new_attributes}, session: valid_session
        recipe.reload
        expect(recipe.name).to eq("Fish!")
      end

      it "assigns the requested recipe as @recipe" do
        put :update, params: {id: recipe.to_param, recipe: valid_attributes}, session: valid_session
        expect(assigns(:recipe)).to eq(recipe)
      end

      it "redirects to the recipe" do
        put :update, params: {id: recipe.to_param, recipe: valid_attributes}, session: valid_session
        expect(response).to redirect_to(recipe)
      end
    end

    context "with invalid params" do
      it "assigns the recipe as @recipe" do
        put :update, params: {id: recipe.to_param, recipe: invalid_attributes}, session: valid_session
        expect(assigns(:recipe)).to eq(recipe)
      end

      it "re-renders the 'edit' template" do
        put :update, params: {id: recipe.to_param, recipe: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end
end
