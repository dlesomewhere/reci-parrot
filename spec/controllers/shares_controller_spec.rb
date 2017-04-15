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

      it "assigns newly created Share as @share" do
        post :create, params: { share: valid_attributes }, session: valid_session

        expect(assigns(:share)).to be_a(Share)
        expect(assigns(:share)).to be_persisted
      end

      it "redirects to ..." do

      end

      it "send an email" do
      end
    end

    context "with invalid params" do
      it "assigns new but unsaved Share as @share" do
        post :create, params: { share: invalid_attributes }, session: valid_session

        expect(assigns(:share)).to be_a(Share)
        expect(assigns(:share)).to_not be_persisted
      end

      it "redirects to ..." do

      end
    end
  end
end
