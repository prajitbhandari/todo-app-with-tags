# FactoryBot.define do
#     factory :todo do
#       item { Faker::Food.dish }
#     end
#   end

  FactoryBot.define do
    factory :todo do
     item {Faker::Food.dish}
     trait :tags_todos do
      #  tags {FactoryBot.create_list(:tag, 1 + rand(Tag.all.size))}
      #  tags {[FactoryBot.create(:tag)]}
      tag_ids {Tag.all.pluck(:id).sample(1 + rand(Tag.all.size))}
     end
    end
  end

  


