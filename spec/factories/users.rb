FactoryBot.define do
  factory :user do
    nickname {Faker::Name.name}
    email {Faker::Internet.free_email}
    password { 'test1234TEST' }
    password_confirmation {password}
    transient do
      person { Gimei.name }
    end
    first_name { person.first.kanji }
    last_name { person.last.kanji }
    first_name_kana { person.first.katakana }
    last_name_kana { person.last.katakana }
    date_of_birth { Faker::Date.birthday(min_age: 19, max_age: 90) }
  end
end