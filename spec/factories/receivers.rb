# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :receiver do
    name 'pony'
    address 'pony receiver address1'
    zip_code '123456'
    phone '13888888888'
    association :province
    association :city
    association :district
  end
end