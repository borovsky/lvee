require "spec_helper"

describe Editor::TranslationsController do
  describe "routing" do

    it "routes to #index" do
      get("/by/editor/translations").should route_to("editor/translations#index",
                                                     lang: "by")
    end

    it "routes to #new" do
      get("/by/editor/translations/new").should route_to("editor/translations#new",
                                                         lang: "by")
    end

    it "routes to #show" do
      get("/by/editor/translations/1").should route_to("editor/translations#show",
                                                       id: "1", lang: "by")
    end

    it "routes to #edit" do
      get("/by/editor/translations/1/edit").should route_to("editor/translations#edit",
                                                            id: "1", lang: "by")
    end

    it "routes to #create" do
      post("/by/editor/translations").should route_to("editor/translations#create",
                                                      lang: "by")
    end

    it "routes to #update" do
      put("/by/editor/translations/1").should route_to("editor/translations#update",
                                                       id: "1", lang: "by")
    end

    it "routes to #destroy" do
      delete("/by/editor/translations/1").should route_to("editor/translations#destroy",
                                                          id: "1", lang: "by")
    end

  end
end
