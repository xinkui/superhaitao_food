# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
    id '1'
    name '厦门市'
    province_id '1'
    level '3'
    zip_code '361000'
    pinyin 'shamen'
    pinyin_abbr 'sm'
  end
end