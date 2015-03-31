
require 'spec_helper'

describe ValueOidsController do

  describe "routing" do

    it "routes to #index" do
      get("/value_oids").should route_to("value_oids#index")
    end

    it "routes to #update" do
      get("/value_oids/1").should route_to("value_oids#show", :id => "1")
    end

    it "routes to #new" do
      get("/value_oids/new").should route_to("value_oids#new")
    end

    it "routes to #edit" do
      get("/value_oids/1/edit").should route_to("value_oids#edit", :id => "1")
    end

    it "routes to #create" do
      post("/value_oids").should route_to("value_oids#create")
    end

    it "routes to #update" do
      put("/value_oids/1").should route_to("value_oids#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/value_oids/1").should route_to("value_oids#destroy", :id => "1")
    end

  end

end