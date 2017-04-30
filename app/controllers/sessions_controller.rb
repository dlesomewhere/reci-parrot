class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :login_attempt]

  def new
  end

  def login_attempt
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to shares_path
    else
      redirect_to login_path
    end
  end

  def create
    auth = Authorization.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = auth.user.id

    if share.present?
      share.update!(recipient: auth.user)
    end

    redirect_to shares_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def share
    @share ||= Share.find_by(token: share_token)
  end

  def share_token
    cookies[:share_token]
  end
end
