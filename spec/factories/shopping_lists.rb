FactoryBot.define do
    factory :shopping_list do
      title { Faker::Lorem.words }
      created_by { Faker::Number.number(10) }
    end
  end