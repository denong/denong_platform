require "rails_helper"

RSpec.describe MerchantSysRegInfosController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/merchant_sys_reg_infos").to route_to("merchant_sys_reg_infos#index")
    end

    it "routes to #new" do
      expect(:get => "/merchant_sys_reg_infos/new").to route_to("merchant_sys_reg_infos#new")
    end

    it "routes to #show" do
      expect(:get => "/merchant_sys_reg_infos/1").to route_to("merchant_sys_reg_infos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/merchant_sys_reg_infos/1/edit").to route_to("merchant_sys_reg_infos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/merchant_sys_reg_infos").to route_to("merchant_sys_reg_infos#create")
    end

    it "routes to #update" do
      expect(:put => "/merchant_sys_reg_infos/1").to route_to("merchant_sys_reg_infos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/merchant_sys_reg_infos/1").to route_to("merchant_sys_reg_infos#destroy", :id => "1")
    end

  end
end
