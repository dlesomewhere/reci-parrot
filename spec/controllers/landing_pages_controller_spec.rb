require "rails_helper"

RSpec.describe LandingPagesController, type: :controller do
  describe "#index" do
    subject { get :index }

    it "returns http success" do
      expect(subject).to have_http_status(:success)
    end
  end
end
