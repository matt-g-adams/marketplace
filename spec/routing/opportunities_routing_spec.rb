require "rails_helper"

RSpec.describe OpportunitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/opportunities").to route_to("opportunities#index")
    end

    it "routes to #create" do
      expect(post: "/opportunities").to route_to("opportunities#create")
    end

    it "routes to #apply" do
      expect(post: "/opportunities/1/apply").to route_to("opportunities#apply", id: "1")
    end
  end
end
