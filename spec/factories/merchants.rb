FactoryBot.define do
  factory :merchant do
    name { Faker::Movies::StarWars.unique.character}
  end
end
