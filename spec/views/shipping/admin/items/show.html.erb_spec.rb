require 'spec_helper'

describe "items/show" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :user_name => "User Name",
      :express_name_internal => "Express Name Internal",
      :express_no_internal => "Express No Internal",
      :weight => "9.99",
      :is_send_mail => false,
      :state => "State",
      :remark => "Remark",
      :cargo_space => "Cargo Space"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User Name/)
    rendered.should match(/Express Name Internal/)
    rendered.should match(/Express No Internal/)
    rendered.should match(/9.99/)
    rendered.should match(/false/)
    rendered.should match(/State/)
    rendered.should match(/Remark/)
    rendered.should match(/Cargo Space/)
  end
end
