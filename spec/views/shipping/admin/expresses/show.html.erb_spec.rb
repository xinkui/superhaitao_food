require 'spec_helper'

describe "expresses/show" do
  before(:each) do
    @express = assign(:express, stub_model(Express,
      :description => "Description",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    rendered.should match(/Name/)
  end
end
