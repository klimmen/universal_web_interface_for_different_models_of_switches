require 'spec_helper'

describe VlansController do

  describe "routing" do

    it "routes to #index" do
      get("172.24.24.24/vlans").should route_to("vlans#index", ip: "172.24.24.24", param: :ip)
    end

    it "routes to #new" do
      get("172.24.24.24/vlans/new").should route_to("vlans#new", ip: "172.24.24.24", param: :ip)
    end

    it "routes to #edit" do
      get("/172.24.24.24/vlans/1/edit").should route_to("vlans#edit", ip: "172.24.24.24", param: :ip, :id => "1")
    end

    it "routes to #create" do
      post("172.24.24.24/vlans").should route_to("vlans#create", ip: "172.24.24.24", param: :ip)
    end

    it "routes to #update" do
      put("172.24.24.24/vlans/1").should route_to("vlans#update", ip: "172.24.24.24", param: :ip, :id => "1")
    end

    it "routes to #destroy" do
      delete("172.24.24.24/vlans/1").should route_to("vlans#destroy", ip: "172.24.24.24", param: :ip, :id => "1")
    end

  end

end