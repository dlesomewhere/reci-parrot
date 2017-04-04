FactoryGirl.define do
  factory :user do
    provider "google_oauth2"
    uid "123456789"
    first_name "John"
    last_name "Doe"
    oauth_token "token"
    oauth_expires_at Time.now + 1.day
  end
end
