# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@a.com"
  end
  sequence :name do |n|
    "user#{n}"
  end
  factory :user do
    email
    name
    password '12345678'
    password_confirmation '12345678'
    point 20
    confirmed_at '2013-08-17 14:31:19.059971'
    confirmation_token nil

    factory :user_recommended do
      name  'recommended'
    end

    factory :user_have_one_order do
      name 'pony'
      after(:create) do |user|
        create_list(:order_with_user, 1, user: user)
      end
      recommended 'recommended'
    end

    factory :user_have_two_order do
      name 'getdown'
      after(:create) do |user|
        create_list(:order_with_user, 2, user: user)
      end
      recommended 'recommended'
    end

    factory :admin do
      name 'admin'
      password 'admin888'
      password_confirmation 'admin888'
      role 'admin'
    end
  end
end
