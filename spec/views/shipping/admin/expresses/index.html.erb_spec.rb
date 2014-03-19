require 'spec_helper'

describe "expresses/index" do
  before(:each) do
    assign(:expresses, [
      stub_model(Express,
        :description => "Description",
        :name => "Name"
      ),
      stub_model(Express,
        :description => "Description",
        :name => "Name"
      )
    ])
  end

  it "renders a list of expresses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
