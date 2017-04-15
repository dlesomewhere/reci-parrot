class SharesMailer < ApplicationMailer
  def notification(share)
    @share = share

    mail(
      to: share.recipient_email,
      from: "no-reply@reciparrot.com",
      subject: "#{@share.sender.full_name} shared a DELICIOUS recipe with you!"
    )
  end
end
