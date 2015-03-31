require 'spec_helper'

describe ValueOidsController do

  describe "routing" do

    it "routes to #index" do
      get("/").should route_to("welcome#index")
    end

  end

end