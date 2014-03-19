# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    association :user, factory: :user
    factory :order_with_user do
      user
    end
  end
end
