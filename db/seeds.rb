# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# admin = User.create!(
#   name: "Tatchagon Koonkoei",
#   email: "o_k_t@hotmail.com",
#   password: "123456",
#   password_confirmation: "123456",
#   admin: true
# )

# all_sale_status = ['active', 'expired', 'trade', 'success', 'fail']

# all_sale_status.each do |name|
#   SaleStatus.create(name: name)
# end

# 100.times do |n|
#   name = Faker::Name.name
#   email = "example2-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(
#       name: name,
#       email: email,
#       password: password,
#       password_confirmation: password
#     )
# end

# # announcements
# announcements_role = ["sale", "purchase"]
# users = User.order("created_at DESC").take(100)

# 5.times do
# users.each{|user|
#     amount = Faker::Number.between(30, 100)
#     price = Faker::Number.between(700, 1000)
#     role = announcements_role[Faker::Number.between(0, 1)]
#     district_id = Faker::Number.between(1, 8913)

#     user.announcements.create!(
#       amount: amount,
#       price: price,
#       role: role,
#       district_id: district_id
#     )
# }
# end

# for i in 0..100
#   user = users[i]
#   user_next = users[i + 1]
#   announcements = user_next.announcements
#   announcements.each do |announcement|
#     amount = announcement.amount
#     price = announcement.price + Faker::Number.between(0, 20)
#     deal = user.deals.create!(amount: amount, price: price)
#     attraction = Attraction.create!(deal: deal, announcement: announcement)
#   end
# end

# deals = Deal.order("created_at DESC").take(500)
# deals.each do |deal|
#   deal.status = "wait"
#   deal.save
# end
