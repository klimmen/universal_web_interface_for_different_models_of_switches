
require 'spec_helper'

describe MibsController do

  describe "routing" do

    it "routes to #index" do

      get("/switch_models/1/firmwares/1/mibs").should route_to("mibs#index", switch_model_id: "1", firmware_id: "1" )
    end

    it "routes to #new" do
      get("/switch_models/1/firmwares/1/mibs/new").should route_to("mibs#new", switch_model_id: "1", firmware_id: "1" )
    end

    it "routes to #edit" do
      get("/switch_models/1/firmwares/1/mibs/1/edit").should route_to("mibs#edit", switch_model_id: "1", firmware_id: "1", :id => "1")
    end

    it "routes to #create" do
      post("/switch_models/1/firmwares/1/mibs").should route_to("mibs#create", switch_model_id: "1", firmware_id: "1")
    end

    it "routes to #update" do
      put("/switch_models/1/firmwares/1/mibs/1").should route_to("mibs#update", switch_model_id: "1", firmware_id: "1", :id => "1")
    end

    it "routes to #destroy" do
      delete("/switch_models/1/firmwares/1/mibs/1").should route_to("mibs#destroy", switch_model_id: "1", firmware_id: "1", :id => "1")
    end

  end

end