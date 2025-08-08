# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { "password" }
  end
end
