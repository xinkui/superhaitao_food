require 'spec_helper'

describe "categories/edit" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :name_cn => "MyString",
      :name_en => "MyString",
      :remark => "MyString"
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", category_path(@category), "post" do
      assert_select "input#category_name_cn[name=?]", "category[name_cn]"
      assert_select "input#category_name_en[name=?]", "category[name_en]"
      assert_select "input#category_remark[name=?]", "category[remark]"
    end
  end
end
