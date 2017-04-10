FactoryGirl.define do
  factory :user do
    provider "google_oauth2"
    sequence :uid { |n| "#{n}" }
    first_name "John"
    last_name "Doe"
    oauth_token "token"
    oauth_expires_at Time.now + 1.day
  end
end
