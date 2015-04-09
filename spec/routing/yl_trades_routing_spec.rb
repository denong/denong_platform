require "rails_helper"

RSpec.describe YlTradesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/yl_trades").to route_to("yl_trades#index")
    end

    it "routes to #new" do
      expect(:get => "/yl_trades/new").to route_to("yl_trades#new")
    end

    it "routes to #show" do
      expect(:get => "/yl_trades/1").to route_to("yl_trades#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/yl_trades/1/edit").to route_to("yl_trades#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/yl_trades").to route_to("yl_trades#create")
    end

    it "routes to #update" do
      expect(:put => "/yl_trades/1").to route_to("yl_trades#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/yl_trades/1").to route_to("yl_trades#destroy", :id => "1")
    end

  end
end
