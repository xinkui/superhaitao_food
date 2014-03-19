# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Weight.delete_all

weight1 = Weight.create(weight: 2)
weight2 = Weight.create(weight: 3)
weight3 = Weight.create(weight: 4)
weight4 = Weight.create(weight: 5)
weight5 = Weight.create(weight: 6)
weight6 = Weight.create(weight: 7)
weight7 = Weight.create(weight: 8)
weight8 = Weight.create(weight: 9)
weight9 = Weight.create(weight: 10)
weight10 = Weight.create(weight: 15)
weight11 = Weight.create(weight: 20)
weight12 = Weight.create(weight: 25)
weight13 = Weight.create(weight: 30)

Price.delete_all

Price.create(weight: weight1, price: 0.01)
Price.create(weight: weight1, price: 0.02)

user = User.where( :email => 'superhaitao@163.com')
User.create(name: 'admin', password: 'admin888', email: 'superhaitao@163.com',
                   confirmed_at: '2013-08-17 14:31:19.059971',
                   confirmation_token: nil) unless user == nil
