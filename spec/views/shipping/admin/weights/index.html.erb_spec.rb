require 'spec_helper'

describe "weights/index" do
  before(:each) do
    assign(:weights, [
      stub_model(Weight,
        :weight => 1
      ),
      stub_model(Weight,
        :weight => 1
      )
    ])
  end

  it "renders a list of weights" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
