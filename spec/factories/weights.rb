# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :weight do
     weight 2
     factory :weight_2kg do
       weight 2
     end
     factory :weight_3kg do
       weight 3
     end

     factory :weight_8kg do
       weight 8
     end

    factory :weight_with_prices do
      ignore do
        price_count 5
      end
      after(:create) do |weight, evaluator|
        create_list(:price_with_weight, evaluator.price_count, weight: weight)
      end
    end
  end
end
