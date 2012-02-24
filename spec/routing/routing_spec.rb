require 'spec_helper'

describe :routes do

  describe "routing" do
    it "routes to /" do
      get("/").should route_to("tengine/core/events#index")
    end
  end

end
