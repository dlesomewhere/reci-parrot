class SharesController < ApplicationController
  def new
    @share = Share.new
  end

  def index
    @received_shares = current_user.received_shares
  end

  def create
    @share = Share.where(share_params).first_or_initialize
    @share.sender = current_user
    @share.recipient = User.where(email: @share.recipient_email).first

    if @share.save
      if @share.recipient.present?
        SharesMailer.notify_existing_user(@share).deliver
      else
        SharesMailer.notify_recipient(@share).deliver
      end

      flash[:notice] = "You've shared a recipe! :party-parrot-shuffle:"
    else

      flash[:error] = @share.errors.full_messages.to_sentence
    end

    redirect_to @share.recipe
  end

  private

  def share_params
    params.require(:share).permit(:recipe_id, :recipient_email)
  end
end
