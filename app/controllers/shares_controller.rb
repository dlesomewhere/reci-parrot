class SharesController < ApplicationController
  def new
    @share = Share.new
  end

  def create
    @share = Share.new(share_params)
    @share.sender = current_user
    @share.recipient = User.where(email: @share.recipient_email).first

    if @share.save
      if @share.recipient.present?
        SharesMailer.notify_existing_user(@share).deliver
      else
        SharesMailer.notify_recipient(@share).deliver
      end
    else
      # something went wrong
      # flash an error?
    end

    redirect_to @share.recipe
  end

  private

  def share_params
    params.require(:share).permit(:recipe_id, :recipient_email)
  end
end
