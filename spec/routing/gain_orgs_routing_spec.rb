require "rails_helper"

RSpec.describe GainOrgsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/gain_orgs").to route_to("gain_orgs#index")
    end

    it "routes to #new" do
      expect(:get => "/gain_orgs/new").to route_to("gain_orgs#new")
    end

    it "routes to #show" do
      expect(:get => "/gain_orgs/1").to route_to("gain_orgs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/gain_orgs/1/edit").to route_to("gain_orgs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/gain_orgs").to route_to("gain_orgs#create")
    end

    it "routes to #update" do
      expect(:put => "/gain_orgs/1").to route_to("gain_orgs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/gain_orgs/1").to route_to("gain_orgs#destroy", :id => "1")
    end

  end
end
