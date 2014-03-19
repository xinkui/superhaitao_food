require 'spec_helper'

describe "prices/index" do
  before(:each) do
    assign(:prices, [
      stub_model(Price,
        :price => "9.99",
        :express_id => "Express",
        :weight_id => "Weight"
      ),
      stub_model(Price,
        :price => "9.99",
        :express_id => "Express",
        :weight_id => "Weight"
      )
    ])
  end

  it "renders a list of prices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Express".to_s, :count => 2
    assert_select "tr>td", :text => "Weight".to_s, :count => 2
  end
end
