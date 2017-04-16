FactoryGirl.define do
  factory :share do
    association :recipe, factory: :recipe
    association :sender, factory: :user
    recipient_email "recipient@example.test"
  end

  trait :with_existing_user do
    association :recipient, factory: :user
  end

  factory :invalid_share, parent: :share do |f|
      f.recipient_email nil
  end
end
