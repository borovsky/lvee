require "spec_helper"

describe ThesisesController do
  describe "routing" do

    it "routes to #index" do
      get("/by/thesises").should route_to("thesises#index", :lang => "by")
    end

    it "routes to #show" do
      get("/by/thesises/1").should route_to("thesises#show", :id => "1", :lang => "by")
    end

    it "routes to #edit" do
      get("/by/thesises/1/edit").should route_to("thesises#edit", :id => "1", :lang => "by")
    end

    it "routes to #create" do
      post("/by/thesises").should route_to("thesises#create", :lang => "by")
    end

    it "routes to #update" do
      put("/by/thesises/1").should route_to("thesises#update", :id => "1", :lang => "by")
    end

    #it "routes to #destroy" do
    #  delete("/by/thesises/1").should route_to("thesises#destroy", :id => "1", :lang => "by")
    #end

  end
end
