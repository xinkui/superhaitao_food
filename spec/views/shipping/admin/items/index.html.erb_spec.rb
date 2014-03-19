require 'spec_helper'

describe "items/index" do
  before(:each) do
    assign(:items, [
      stub_model(Item,
        :user_name => "User Name",
        :express_name_internal => "Express Name Internal",
        :express_no_internal => "Express No Internal",
        :weight => "9.99",
        :is_send_mail => false,
        :state => "State",
        :remark => "Remark",
        :cargo_space => "Cargo Space"
      ),
      stub_model(Item,
        :user_name => "User Name",
        :express_name_internal => "Express Name Internal",
        :express_no_internal => "Express No Internal",
        :weight => "9.99",
        :is_send_mail => false,
        :state => "State",
        :remark => "Remark",
        :cargo_space => "Cargo Space"
      )
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User Name".to_s, :count => 2
    assert_select "tr>td", :text => "Express Name Internal".to_s, :count => 2
    assert_select "tr>td", :text => "Express No Internal".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Remark".to_s, :count => 2
    assert_select "tr>td", :text => "Cargo Space".to_s, :count => 2
  end
end
