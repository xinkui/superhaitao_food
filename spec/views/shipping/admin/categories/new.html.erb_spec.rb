require 'spec_helper'

describe "categories/new" do
  before(:each) do
    assign(:category, stub_model(Category,
      :name_cn => "MyString",
      :name_en => "MyString",
      :remark => "MyString"
    ).as_new_record)
  end

  it "renders new category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", categories_path, "post" do
      assert_select "input#category_name_cn[name=?]", "category[name_cn]"
      assert_select "input#category_name_en[name=?]", "category[name_en]"
      assert_select "input#category_remark[name=?]", "category[remark]"
    end
  end
end
