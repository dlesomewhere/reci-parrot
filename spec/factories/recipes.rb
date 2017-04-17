FactoryGirl.define do
  factory :recipe do
    url "http://www.recipes.test/recipe"
    name "MyString"
  end

  factory :invalid_recipe, parent: :recipe do |f|
      f.url nil
  end
end
