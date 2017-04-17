require "rails_helper"

RSpec.describe SharesController, type: :controller do
  let(:valid_attributes) { FactoryGirl.build(:share).attributes }
  let(:invalid_attributes) { FactoryGirl.build(:invalid_share).attributes }

  let(:user) { FactoryGirl.create(:user) }
  let(:valid_session) { { user_id: user.id } }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Share" do
        expect {
          post :create, params: { share: valid_attributes }, session: valid_session
        }.to change { Share.count }.by(1)
      end

      it "doesn't duplicate the same share" do
        post :create, params: { share: valid_attributes }, session: valid_session

        expect {
          post :create, params: { share: valid_attributes }, session: valid_session
        }.to_not change { Share.count }
      end

      it "assigns newly created Share as @share" do
        post :create, params: { share: valid_attributes }, session: valid_session

        expect(assigns(:share)).to be_a(Share)
        expect(assigns(:share)).to be_persisted
      end

      it "redirects to the recipe shared" do
        post :create, params: { share: valid_attributes }, session: valid_session
        expect(response).to redirect_to(assigns(:share).recipe)
      end
    end

    context "with invalid params" do
      it "assigns new but unsaved Share as @share" do
        post :create, params: { share: invalid_attributes }, session: valid_session

        expect(assigns(:share)).to be_a(Share)
        expect(assigns(:share)).to_not be_persisted
      end
    end

    context "when the recipient doesn't exist" do
      before :each do
        ActionMailer::Base.deliveries = []

        post :create, params: { share: valid_attributes }, session: valid_session
      end

      it "sends an email to the recipient" do
        share = assigns(:share)
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        expect(
          ActionMailer::Base.deliveries.last.subject
        ).to eq("#{share.sender.full_name} shared a DELICIOUS recipe with you!")
        expect(ActionMailer::Base.deliveries.last.to).to match_array(share.recipient_email)
      end
    end

    context "when the recipient exists" do
      let!(:recipient) { FactoryGirl.create(:user) }

      before :each do
        valid_attributes["recipient_email"] = recipient.email
        ActionMailer::Base.deliveries = []

        post :create, params: { share: valid_attributes }, session: valid_session
      end

      it "adds the recipe to the recipient" do
        expect(recipient.reload.received_recipes).to match_array(assigns(:share).recipe)
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        expect(
          ActionMailer::Base.deliveries.last.subject
        ).to eq("Reciparrot has a DELICIOUS recipe for you!")
        expect(ActionMailer::Base.deliveries.last.to).to match_array(recipient.email)
      end
    end
  end
end
