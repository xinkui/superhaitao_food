# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brand do
    name_cn '品牌1'
    name_en 'pinpai1'
    factory :brand_2 do
      name_cn '品牌2'
      name_en 'pinpai2'
    end
    factory :brand_3 do
      name_cn '品牌3'
      name_en 'pinpai3'
    end
    factory :brand_4 do
      name_cn '品牌4'
      name_en 'pinpai4'
    end
    factory :brand_5 do
      name_cn '品牌5'
      name_en 'pinpai5'
    end
  end
end
