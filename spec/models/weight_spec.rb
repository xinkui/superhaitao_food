require 'spec_helper'

describe Weight do
  it 'test assocation' do
    weight = FactoryGirl.create(:weight_with_prices)
    weight.prices.length.should == 5
  end
end
