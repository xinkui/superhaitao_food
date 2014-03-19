require 'spec_helper'

describe "brands/index" do
  before(:each) do
    assign(:brands, [
      stub_model(Brand,
        :name_cn => "Name Cn",
        :name_en => "Name En",
        :remark => "Remark"
      ),
      stub_model(Brand,
        :name_cn => "Name Cn",
        :name_en => "Name En",
        :remark => "Remark"
      )
    ])
  end

  it "renders a list of brands" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Cn".to_s, :count => 2
    assert_select "tr>td", :text => "Name En".to_s, :count => 2
    assert_select "tr>td", :text => "Remark".to_s, :count => 2
  end
end
