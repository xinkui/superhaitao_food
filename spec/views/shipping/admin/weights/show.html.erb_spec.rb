require 'spec_helper'

describe "weights/show" do
  before(:each) do
    @weight = assign(:weight, stub_model(Weight,
      :weight => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
