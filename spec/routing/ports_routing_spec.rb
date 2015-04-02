require 'spec_helper'

describe PortsController do

  describe "routing" do

    it "routes to #index" do
      get("172.24.24.24/ports").should route_to("ports#index", ip: "172.24.24.24")
    end

    it "routes to #update_ports" do
      post("/172.24.24.24/ports/update_ports").should route_to("ports#update_ports", ip: "172.24.24.24")
    end

  end

end