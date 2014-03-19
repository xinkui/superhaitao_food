require 'spec_helper'

describe "expresses/edit" do
  before(:each) do
    @express = assign(:express, stub_model(Express,
      :description => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit express form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", express_path(@express), "post" do
      assert_select "input#express_description[name=?]", "express[description]"
      assert_select "input#express_name[name=?]", "express[name]"
    end
  end
end
