# Preview all emails at http://localhost:3000/rails/mailers/shares_mailer
class SharesMailerPreview < ActionMailer::Preview
  def notification
    share = Share.first
    SharesMailer.notification(share)
  end
end
