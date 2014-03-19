require 'spec_helper'

describe "skus/new" do
  before(:each) do
    assign(:sku, stub_model(Sku,
      :name => "MyString",
      :long => "9.99",
      :wide => "9.99",
      :high => "9.99",
      :volume => "9.99",
      :actual_weight => "9.99",
      :barcode => "MyString",
      :remark => "MyString"
    ).as_new_record)
  end

  it "renders new sku form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", skus_path, "post" do
      assert_select "input#sku_name[name=?]", "sku[name]"
      assert_select "input#sku_long[name=?]", "sku[long]"
      assert_select "input#sku_wide[name=?]", "sku[wide]"
      assert_select "input#sku_high[name=?]", "sku[high]"
      assert_select "input#sku_volume[name=?]", "sku[volume]"
      assert_select "input#sku_actual_weight[name=?]", "sku[actual_weight]"
      assert_select "input#sku_barcode[name=?]", "sku[barcode]"
      assert_select "input#sku_remark[name=?]", "sku[remark]"
    end
  end
end
