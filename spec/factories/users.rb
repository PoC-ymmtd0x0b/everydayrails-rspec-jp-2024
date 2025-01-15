FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { 'Tanaka' }
    last_name  { 'Taro' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password   { 'foobar' }
  end
end
