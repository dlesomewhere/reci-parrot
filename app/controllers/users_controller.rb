class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    update_share_token_cookie
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      share.update!(recipient: @user) if share.present?
      redirect_to shares_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def share
    @share ||= Share.find_by(token: share_token)
  end

  def share_token
    update_share_token_cookie
    cookies[:share_token]
  end

  def update_share_token_cookie
    cookies[:share_token] = params[:share_token] if params[:share_token].present?
  end
end
