# Preview all emails at http://localhost:3000/rails/mailers/shares_mailer
class SharesMailerPreview < ActionMailer::Preview
  def notify_existing_user
    SharesMailer.notify_existing_user(Share.first)
  end

  def notify_recipient
    SharesMailer.notify_recipient(Share.first)
  end
end
