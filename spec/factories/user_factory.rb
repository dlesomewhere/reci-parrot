FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    sequence :email { |n| "John@domain#{n}.test" }
    password_digest "blahblahblah"
  end

  factory :user_with_password, parent: :user do |f|
    password "password"
    password_confirmation "password"
  end

  factory :invalid_user, parent: :user do |f|
    password "pw"
  end
end
