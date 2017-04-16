require "rails_helper"

RSpec.describe SharesMailer, type: :mailer do
  describe "#notify_existing_user" do
    let!(:share) { FactoryGirl.create(:share, :with_existing_user) }
    subject { SharesMailer.notify_existing_user(share) }

    it "sends a mail when deliver is called" do
      expect {
        subject.deliver
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "has the expected recipients" do
      expect(subject.to).to match_array(share.recipient_email)
    end

    it "has the expected sender" do
      expect(subject.from).to match_array("no-reply@reciparrot.com")
    end

    it "has the expected subject line" do
      expected_subject = "Reciparrot has a DELICIOUS recipe for you!"
      expect(subject.subject).to eq(expected_subject)
    end
  end

  describe "#notify_recipient" do
    let!(:share) { FactoryGirl.create(:share) }
    subject { SharesMailer.notify_recipient(share) }

    it "sends a mail when deliver is called" do
      expect {
        subject.deliver
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "has the expected recipients" do
      expect(subject.to).to match_array(share.recipient_email)
    end

    it "has the expected sender" do
      expect(subject.from).to match_array("no-reply@reciparrot.com")
    end

    it "has the expected subject line" do
      expected_subject = "#{share.sender.full_name} shared a DELICIOUS recipe with you!"
      expect(subject.subject).to eq(expected_subject)
    end
  end
end
