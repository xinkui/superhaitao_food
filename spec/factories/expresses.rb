# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :express do
    factory :express_dhl do
      name 'DHL'
      description 'DHL'
    end
    factory :express_bpost do
      name 'BPOST'
      description 'BPOST'
    end
  end
end
