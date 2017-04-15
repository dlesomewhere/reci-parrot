class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id

    if (token = request.env['omniauth.params']['share_token']).present?
      share = Share.where(token: token).first
      user.recipe_book_pages.create(recipe: share.recipe)
    end

    redirect_to recipes_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
