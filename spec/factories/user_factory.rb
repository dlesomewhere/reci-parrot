FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    sequence :email { |n| "John@domain#{n}.test" }
    password_digest "blahblahblah"
  end
end
