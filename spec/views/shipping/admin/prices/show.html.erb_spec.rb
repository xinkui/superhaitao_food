require 'spec_helper'

describe "prices/show" do
  before(:each) do
    @price = assign(:price, stub_model(Price,
      :price => "9.99",
      :express_id => "Express",
      :weight_id => "Weight"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    rendered.should match(/Express/)
    rendered.should match(/Weight/)
  end
end
