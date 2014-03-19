require "spec_helper"

describe ExpressesController do
  describe "routing" do

    it "routes to #index" do
      get("/expresses").should route_to("expresses#index")
    end

    it "routes to #new" do
      get("/expresses/new").should route_to("expresses#new")
    end

    it "routes to #show" do
      get("/expresses/1").should route_to("expresses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/expresses/1/edit").should route_to("expresses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/expresses").should route_to("expresses#create")
    end

    it "routes to #update" do
      put("/expresses/1").should route_to("expresses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/expresses/1").should route_to("expresses#destroy", :id => "1")
    end

  end
end
