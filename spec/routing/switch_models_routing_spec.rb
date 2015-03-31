
require 'spec_helper'

describe SwitchModelsController do
	
	describe "routing" do

		it "routes to #index" do
			get("/switch_models").should route_to("switch_models#index")
		end

		it "routes to #new" do
			get("/switch_models/new").should route_to("switch_models#new")
		end

		it "routes to #edit" do
			get("/switch_models/1/edit").should route_to("switch_models#edit", :id => "1")
		end

		it "routes to #create" do
			post("/switch_models").should route_to("switch_models#create")
		end

		it "routes to #update" do
			put("/switch_models/1").should route_to("switch_models#update", :id => "1")
		end

		it "routes to #destroy" do
			delete("/switch_models/1").should route_to("switch_models#destroy", :id => "1")
		end

	end

end