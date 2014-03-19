# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name_cn '分类1'
    name_en 'fenlei1'
    factory :category_2 do
      name_cn '分类2'
      name_en 'fenlei2'
    end
    factory :category_3 do
      name_cn '分类3'
      name_en 'fenlei3'
    end
    factory :category_4 do
      name_cn '分类4'
      name_en 'fenlei4'
    end
    factory :category_5 do
      name_cn '分类5'
      name_en 'fenlei5'
    end
  end
end
