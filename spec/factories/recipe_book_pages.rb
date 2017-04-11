FactoryGirl.define do
  factory :recipe_book_page do
    association :user, factory: :user
    association :recipe, factory: :recipe
  end
end
