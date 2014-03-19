# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price do
    price 100

    factory :price_weight_2kg do
      price 100
      association :weight, factory: :weight_2kg
    end

    factory :price_with_weight do
      price 100
      weight
    end

    factory :price_weight_8kg do
      price 100
      association :weight, factory: :weight_8kg
    end
  end
end
