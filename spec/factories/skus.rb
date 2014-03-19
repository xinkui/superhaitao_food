# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sku do
    name '奶粉'
    length '2'
    width '3'
    height '4'
    volume '24'
    actual_weight '2'
    barcode '22334455'
    name_en 'naifen'
    purchase_price '100.0'
    association :brand
    association :category
    factory :sku_2 do
      name '苹果'
      name_en 'apple'
      association :brand, factory: :brand_2
      association :category, factory: :category_2
      barcode '2'
    end
    factory :sku_3 do
      name 'sku3'
      name_en 'sku3'
      association :brand, factory: :brand_3
      association :category, factory: :category_3
      barcode '3'
    end
    factory :sku_4 do
      name 'sku4'
      name_en 'sku4'
      association :brand, factory: :brand_4
      association :category, factory: :category_4
      barcode '4'
    end
    factory :sku_5 do
      name 'sku5'
      name_en 'sku5'
      association :brand, factory: :brand_5
      association :category, factory: :category_5
      barcode '5'
    end
  end
end
