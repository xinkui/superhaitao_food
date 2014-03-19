require 'spec_helper'

describe "prices/edit" do
  before(:each) do
    @price = assign(:price, stub_model(Price,
      :price => "9.99",
      :express_id => "MyString",
      :weight_id => "MyString"
    ))
  end

  it "renders the edit price form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", price_path(@price), "post" do
      assert_select "input#price_price[name=?]", "price[price]"
      assert_select "input#price_express_id[name=?]", "price[express_id]"
      assert_select "input#price_weight_id[name=?]", "price[weight_id]"
    end
  end
end
