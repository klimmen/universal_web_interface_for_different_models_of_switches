
require 'spec_helper'

describe FirmwaresController do

  describe "routing" do



    it "routes to #new" do
      get("/switch_models/1/firmwares/new").should route_to("firmwares#new", switch_model_id: "1" )
    end

    it "routes to #edit" do
      get("/switch_models/1/firmwares/1/edit").should route_to("firmwares#edit", switch_model_id: "1", :id => "1")
    end

    it "routes to #create" do
      post("/switch_models/1/firmwares").should route_to("firmwares#create", switch_model_id: "1")
    end

    it "routes to #update" do
      put("/switch_models/1/firmwares/1").should route_to("firmwares#update", switch_model_id: "1", :id => "1")
    end

    it "routes to #destroy" do
      delete("/switch_models/1/firmwares/1").should route_to("firmwares#destroy", switch_model_id: "1", :id => "1")
    end

  end

end