# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :district do
    id '1'
    name '思明区'
    city_id '1'
    pinyin 'siming'
    pinyin_abbr 'sm'
  end
end