class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

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
    @share_token ||= request.env["omniauth.params"]&.fetch("share_token", nil)
  end
end
