require "rails_helper"

RSpec.describe ConsumeMessagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/consume_messages").to route_to("consume_messages#index")
    end

    it "routes to #new" do
      expect(:get => "/consume_messages/new").to route_to("consume_messages#new")
    end

    it "routes to #show" do
      expect(:get => "/consume_messages/1").to route_to("consume_messages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/consume_messages/1/edit").to route_to("consume_messages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/consume_messages").to route_to("consume_messages#create")
    end

    it "routes to #update" do
      expect(:put => "/consume_messages/1").to route_to("consume_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/consume_messages/1").to route_to("consume_messages#destroy", :id => "1")
    end

  end
end
