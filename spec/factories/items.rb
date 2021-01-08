FactoryBot.define do
  factory :item do
    title { Faker::Lorem.words }
    info { Faker::Lorem.sentence }
    category_id { 2 }
    status_id { 2 }
    shipping_fee_id { 2 }
    prefecture_id { 14 }
    delivery_day_id { 2 }
    price { Faker::Number.between(from: 300, to: 9999999) }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/test_image.png'), filename: 'test_image.png')
    end
  end
end
