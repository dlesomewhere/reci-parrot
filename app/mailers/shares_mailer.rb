class SharesMailer < ApplicationMailer
  def notify_existing_user(share)
    @share = share

    mail(
      to: share.recipient_email,
      from: "no-reply@reciparrot.com",
      subject: "Reciparrot has a DELICIOUS recipe for you!"
    )
  end

  def notify_recipient(share)
    @share = share

    mail(
      to: share.recipient_email,
      from: "no-reply@reciparrot.com",
      subject: "#{@share.sender.full_name} shared a DELICIOUS recipe with you!"
    )
  end
end
