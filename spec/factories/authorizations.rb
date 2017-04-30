FactoryGirl.define do
  factory :authorization do
    provider "MyString"
    uid "MyString"
    association :user, factory: :user
  end
end
