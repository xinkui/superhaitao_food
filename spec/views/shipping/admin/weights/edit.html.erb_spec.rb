require 'spec_helper'

describe "weights/edit" do
  before(:each) do
    @weight = assign(:weight, stub_model(Weight,
      :weight => 1
    ))
  end

  it "renders the edit weight form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", weight_path(@weight), "post" do
      assert_select "input#weight_weight[name=?]", "weight[weight]"
    end
  end
end
