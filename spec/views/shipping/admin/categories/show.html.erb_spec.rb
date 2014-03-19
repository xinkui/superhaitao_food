require 'spec_helper'

describe "categories/show" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :name_cn => "Name Cn",
      :name_en => "Name En",
      :remark => "Remark"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name Cn/)
    rendered.should match(/Name En/)
    rendered.should match(/Remark/)
  end
end
