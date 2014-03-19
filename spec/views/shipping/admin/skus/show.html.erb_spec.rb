require 'spec_helper'

describe "skus/show" do
  before(:each) do
    @sku = assign(:sku, stub_model(Sku,
      :name => "Name",
      :long => "9.99",
      :wide => "9.99",
      :high => "9.99",
      :volume => "9.99",
      :actual_weight => "9.99",
      :barcode => "Barcode",
      :remark => "Remark"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/9.99/)
    rendered.should match(/Barcode/)
    rendered.should match(/Remark/)
  end
end
