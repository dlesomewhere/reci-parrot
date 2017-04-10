json.extract! recipe, :id, :url, :name, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
