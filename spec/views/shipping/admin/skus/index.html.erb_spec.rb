require 'spec_helper'

describe "skus/index" do
  before(:each) do
    assign(:skus, [
      stub_model(Sku,
        :name => "Name",
        :long => "9.99",
        :wide => "9.99",
        :high => "9.99",
        :volume => "9.99",
        :actual_weight => "9.99",
        :barcode => "Barcode",
        :remark => "Remark"
      ),
      stub_model(Sku,
        :name => "Name",
        :long => "9.99",
        :wide => "9.99",
        :high => "9.99",
        :volume => "9.99",
        :actual_weight => "9.99",
        :barcode => "Barcode",
        :remark => "Remark"
      )
    ])
  end

  it "renders a list of skus" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Barcode".to_s, :count => 2
    assert_select "tr>td", :text => "Remark".to_s, :count => 2
  end
end
