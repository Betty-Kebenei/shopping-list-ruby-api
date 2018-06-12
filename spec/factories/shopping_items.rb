FactoryBot.define do
    factory :shopping_item do
      item_name { Faker::StarWars.character }
      quantity { Faker::Number.positive }
      units { Faker::Measurement.volume }
      price { Faker::Number.positive }
      currency { Faker::Currency.code }
      bought false
      shopping_list_id nil
    end
  end