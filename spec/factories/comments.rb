FactoryBot.define do
  factory :comment do
    comment_text { Faker::Lorem.sentence }
    association :user
    association :item
  end
end
