require 'spec_helper'

describe "brands/edit" do
  before(:each) do
    @brand = assign(:brand, stub_model(Brand,
      :name_cn => "MyString",
      :name_en => "MyString",
      :remark => "MyString"
    ))
  end

  it "renders the edit brand form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", brand_path(@brand), "post" do
      assert_select "input#brand_name_cn[name=?]", "brand[name_cn]"
      assert_select "input#brand_name_en[name=?]", "brand[name_en]"
      assert_select "input#brand_remark[name=?]", "brand[remark]"
    end
  end
end
