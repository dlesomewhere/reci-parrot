class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = current_user.received_recipes
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @share = Share.new(recipe: @recipe, sender: current_user)
    @my_shares = Share.with_other_user.where(sender: current_user, recipe: @recipe)
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.
      where(url: recipe_params[:url], name: recipe_params[:name]).
      first_or_create

    share = current_user.received_shares.where(recipe: @recipe).first_or_initialize(
      sender: current_user,
      recipient_email: current_user.email
    )

    respond_to do |format|
      if @recipe.save && share.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      begin
        @recipe = current_user.received_recipes.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to shares_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:url, :name)
    end
end
