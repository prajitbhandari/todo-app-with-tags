FactoryBot.define do
  factory :tag do
    name { Faker::Food.description }
  end
end

