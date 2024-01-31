FactoryBot.define do
  factory :task do
    title { Faker::Name.name }
    body { Faker::Lorem.paragraph }
  end
end
  