# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#

recipe = Recipe.create(
  name: "DELICIOUS eggs",
  url: "http://example.test"
)

user1 = User.create(
  uid: 1,
  provider: "google_oauth2",
  first_name: "Hank",
  last_name: "Scorpio",
  email: "hank.scorpio@globex.test"
)

user2 = User.create(
  uid: 2,
  provider: "google_oauth2",
  first_name: "Montgomery",
  last_name: "Burns",
  email: "monty@burns.test"
)

Share.create(
  recipe: recipe,
  sender: user1,
  recipient: user2,
  recipient_email: "monty@burns.test",
)

Share.create(
  recipe: recipe,
  sender: user1,
  recipient_email: "homer@compuhyperglobalmeganet.test",
)
