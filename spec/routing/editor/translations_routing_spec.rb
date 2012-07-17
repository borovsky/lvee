require "spec_helper"

describe Editor::TranslationsController do
  describe "routing" do

    it "routes to #index" do
      get("/editor/translations").should route_to("editor/translations#index")
    end

    it "routes to #new" do
      get("/editor/translations/new").should route_to("editor/translations#new")
    end

    it "routes to #show" do
      get("/editor/translations/1").should route_to("editor/translations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/editor/translations/1/edit").should route_to("editor/translations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/editor/translations").should route_to("editor/translations#create")
    end

    it "routes to #update" do
      put("/editor/translations/1").should route_to("editor/translations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/editor/translations/1").should route_to("editor/translations#destroy", :id => "1")
    end

  end
end
