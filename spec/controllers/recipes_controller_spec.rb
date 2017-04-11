require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  let(:recipe_book_page) { FactoryGirl.create(:recipe_book_page) }
  let(:recipe) { recipe_book_page.recipe }
  let(:user) { recipe_book_page.user }

  let(:valid_session) { { user_id: user.id } }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:invalid_recipe) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:recipe) }

  let(:other_recipe_book_page) { FactoryGirl.create(:recipe_book_page) }
  let!(:other_recipe) { other_recipe_book_page.recipe }

  describe "GET #index" do
    it "assigns recipes for user as @recipes" do
      get :index, session: valid_session
      expect(assigns(:recipes)).to eq([recipe])
    end
  end

  describe "GET #show" do
    it "assigns the requested recipe as @recipe" do
      get :show, params: {id: recipe.to_param}, session: valid_session
      expect(assigns(:recipe)).to eq(recipe)
    end

    it "redirects to recipes_path if recipe belongs to another user" do
      get :show, params: {id: other_recipe.to_param}, session: valid_session
      expect(response).to redirect_to(recipes_path)
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

    it "redirects to recipes_path if recipe belongs to another user" do
      get :edit, params: {id: other_recipe.to_param}, session: valid_session
      expect(response).to redirect_to(recipes_path)
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
        expect(response).to redirect_to(Recipe.last)
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

  describe "DELETE #destroy" do
    before :each do
      recipe.save!
    end

    it "destroys the requested recipe" do
      expect {
        delete :destroy, params: {id: recipe.to_param}, session: valid_session
      }.to change(Recipe, :count).by(-1)
    end

    it "redirects to the recipes list" do
      delete :destroy, params: {id: recipe.to_param}, session: valid_session
      expect(response).to redirect_to(recipes_url)
    end

    it "redirects to recipes_path when recipe belongs to another user" do
      expect {
        delete :destroy, params: {id: other_recipe.to_param}, session: valid_session
      }.to_not change(Recipe, :count)
      expect(response).to redirect_to(recipes_url)
    end
  end
end
