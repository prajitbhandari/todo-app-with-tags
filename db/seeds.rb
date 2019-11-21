# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Tag.destroy_all
# tag = Tag.create!([{
#        name: "Fun"
#    },
#
#    {
#        name: "Cloth"
#    },
#
#    {
#        name: "Study"
#    },
#
#    {
#        name: "Eat"
#    },
#
#    {
#        name: "Enjoy"
#    }])
#
# Todo.destroy_all
# Todo.create!([{
#        item: "Go To Trek", tag_ids: [tag[0].id, tag[2].id]
#     },
#
#     {
#         item: "Buy clothes", tag_ids: [tag[3].id, tag[4].id]
#     },
#
#     {
#         item: "Read Book", tag_ids: [tag[0].id, tag[4].id]
#     },
#
#     {
#         item: "Buy Bread", tag_ids: [tag[0].id]
#     },
#
#     {
#         item: "Go to Market", tag_ids: [tag[1].id, tag[2].id]
#     },
#
#     {
#         item: "Take Medicine", tag_ids: [tag[3].id, tag[4].id]
#     },
#
#     {
#         item: "Go to school", tag_ids: [tag[0].id]
#     },
#
#     {
#         item: "Play Football", tag_ids: [tag[0].id]
#     },
#
#     {
#         item: "Order Food", tag_ids: [tag[0].id]
#     },
#
#     {
#        item: "Watch Tv", tag_ids: [tag[4].id]
#     }])
# Todo.destroy_all
# Tag.destroy_all
#
# tag_array = ["Health", "Education", "Finance", "Entertainent", "Social"]
# tag_array.each do |t|
#   Tag.create!(name: t)
# end
#
# todo_array = ["Todo1","Todo2","Todo3","Todo4","Todo5","Todo6","Todo7","Todo8","Todo9","Todo10"]
# todo_array.each do |i|
#   array_of_all_tag_ids = Tag.pluck(:id).sample(1 + rand(Tag.all.size))
#   # pluck returns the array of praticular selected attributes
#   # Tag.pluck(:id).map {|num| num.sample(1 + rand(Tag.all.size))}
#   Todo.create!(item: i, tag_ids: array_of_all_tag_ids)
# end
#
# # x = array_of_tag_ids_with_random_sample_size
# # array_of_all_tag_ids = nil use map
# # sample_tag_ids = array_of_all_tag_ids.sample(rand(2) sample_tag_ids = array_of_all_tag_ids.sample(rand(2)
#

# Seeding using Faker

Tag.destroy_all
Todo.destroy_all

5.times do
  Tag.create!(name: Faker::Food.description)
end
10.times do
  array_of_all_tag_ids = Tag.pluck(:id).sample(1 + rand(Tag.all.size))
  Todo.create!(item: Faker::Food.dish, tag_ids: array_of_all_tag_ids)
end













