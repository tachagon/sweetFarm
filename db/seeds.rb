# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create!(
  name: "Tatchagon Koonkoei",
  email: "o_k_t@hotmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true
)

all_sale_status = ['active', 'expired', 'trade', 'success', 'fail']

all_sale_status.each do |name|
  SaleStatus.create(name: name)
end
