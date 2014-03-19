require 'spec_helper'

describe "items/edit" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :user_name => "MyString",
      :express_name_internal => "MyString",
      :express_no_internal => "MyString",
      :weight => "9.99",
      :is_send_mail => false,
      :state => "MyString",
      :remark => "MyString",
      :cargo_space => "MyString"
    ))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", item_path(@item), "post" do
      assert_select "input#item_user_name[name=?]", "item[user_name]"
      assert_select "input#item_express_name_internal[name=?]", "item[express_name_internal]"
      assert_select "input#item_express_no_internal[name=?]", "item[express_no_internal]"
      assert_select "input#item_weight[name=?]", "item[weight]"
      assert_select "input#item_is_send_mail[name=?]", "item[is_send_mail]"
      assert_select "input#item_state[name=?]", "item[state]"
      assert_select "input#item_remark[name=?]", "item[remark]"
      assert_select "input#item_cargo_space[name=?]", "item[cargo_space]"
    end
  end
end
