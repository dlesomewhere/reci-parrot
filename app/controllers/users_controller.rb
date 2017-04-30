class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # FIXME: handle the error if email is already taken a bit more gracefully???
    if @user.save!
      flash[:notice] = "You've signed up! :party-parrot-shuffle:"
      session[:user_id] = @user.id
      redirect_to shares_path
    else
      flash[:notice] = "Error!"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
