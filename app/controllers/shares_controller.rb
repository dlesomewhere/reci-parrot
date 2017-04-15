class SharesController < ApplicationController
  def create
    @share = Share.new(share_params)
    @share.sender = current_user

    if @share.save
      Rails.logger.info "[SharesController] http://localhost:3000/auth/google_oauth2?share_token=#{@share.token}"
      # send email
    else
      # something went wrong
    end
  end

  private

  def share_params
    params.require(:share).permit(:recipe_id, :recipient_email)
  end
end
