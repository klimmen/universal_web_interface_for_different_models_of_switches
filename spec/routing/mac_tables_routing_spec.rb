require 'spec_helper'

describe MacTablesController do

  describe "routing" do

    it "routes to #index" do
      get("172.24.24.24/vlans").should route_to("vlans#index", ip: "172.24.24.24")
    end

    it "routes to mac_tables_search #" do
      post("172.24.24.24/mac_tables/search").should route_to("mac_tables#search", ip: "172.24.24.24")
    end

  end

end