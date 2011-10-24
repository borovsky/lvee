require "spec_helper"

describe AbstractsController do
  describe "routing" do

    it "routes to #index" do
      get("/by/abstracts").should route_to("abstracts#index", :lang => "by")
    end

    it "routes to #show" do
      get("/by/abstracts/1").should route_to("abstracts#show", :id => "1", :lang => "by")
    end

    it "routes to #edit" do
      get("/by/abstracts/1/edit").should route_to("abstracts#edit", :id => "1", :lang => "by")
    end

    it "routes to #create" do
      post("/by/abstracts").should route_to("abstracts#create", :lang => "by")
    end

    it "routes to #update" do
      put("/by/abstracts/1").should route_to("abstracts#update", :id => "1", :lang => "by")
    end

    #it "routes to #destroy" do
    #  delete("/by/abstracts/1").should route_to("abstracts#destroy", :id => "1", :lang => "by")
    #end

  end
end
