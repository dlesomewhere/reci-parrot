FactoryGirl.define do
  factory :recipe do
    url "MyString"
    name "MyString"
  end

  factory :invalid_recipe, parent: :recipe do |f|
      f.url nil
  end
end
