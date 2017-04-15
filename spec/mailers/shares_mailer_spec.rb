require "rails_helper"

RSpec.describe SharesMailer, type: :mailer do
  describe "#notification" do
    let!(:share) { FactoryGirl.create(:share) }
    subject { SharesMailer.notification(share) }

    it "sends a mail when deliver is called" do
      expect {
        subject.deliver
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "has the expected recipients" do
      expect(subject.deliver.to).to match_array(share.recipient_email)
    end

    it "has the expected sender" do
      expect(subject.deliver.from).to match_array("no-reply@reciparrot.com")
    end

    it "has the expected subject line" do
      expected_subject = "#{share.sender.full_name} shared a DELICIOUS recipe with you!"
      expect(subject.deliver.subject).to eq(expected_subject)
    end
  end
end
