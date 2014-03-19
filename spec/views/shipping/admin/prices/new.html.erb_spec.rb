require 'spec_helper'

describe "prices/new" do
  before(:each) do
    assign(:price, stub_model(Price,
      :price => "9.99",
      :express_id => "MyString",
      :weight_id => "MyString"
    ).as_new_record)
  end

  it "renders new price form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", prices_path, "post" do
      assert_select "input#price_price[name=?]", "price[price]"
      assert_select "input#price_express_id[name=?]", "price[express_id]"
      assert_select "input#price_weight_id[name=?]", "price[weight_id]"
    end
  end
end
