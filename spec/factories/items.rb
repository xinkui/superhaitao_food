# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    association :user
    weight 2
    state :new
    association :sku
    express_name_internal 'dhl'
    express_no_internal '123'
    factory :item_with_weight_1kg do
      association :sku, factory: :sku_2
      weight 1
    end
    factory :item_with_weight_1kg_other_sku do
      association :sku, factory: :sku_3
      weight 1
    end
    factory :item_with_order do
      association :sku, factory: :sku_4
      association :order
      state :created_order
    end
    factory :item_with_weight_7kg do
      association :sku, factory: :sku_5
      weight 7
    end
  end
end
