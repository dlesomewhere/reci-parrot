require "rails_helper"

RSpec.describe RecipeController, type: :controller do
  before :each do
    user = FactoryGirl.create(:user)
    session[:user_id] = user.id
  end

  describe "#index" do
    subject { get :index }

    it "returns http success" do
      expect(subject).to have_http_status(:success)
    end
  end
end
