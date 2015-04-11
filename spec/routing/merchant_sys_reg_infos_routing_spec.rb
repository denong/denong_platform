require "rails_helper"

RSpec.describe MerchantSysRegInfosController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/merchant_sys_reg_info/new").to route_to("merchant_sys_reg_infos#new")
    end

    it "routes to #show" do
      expect(:get => "/merchant_sys_reg_info").to route_to("merchant_sys_reg_infos#show")
    end

    it "routes to #edit" do
      expect(:get => "/merchant_sys_reg_info/edit").to route_to("merchant_sys_reg_infos#edit")
    end

    it "routes to #create" do
      expect(:post => "/merchant_sys_reg_info").to route_to("merchant_sys_reg_infos#create")
    end

    it "routes to #update" do
      expect(:put => "/merchant_sys_reg_info").to route_to("merchant_sys_reg_infos#update")
    end

    it "routes to #destroy" do
      expect(:delete => "/merchant_sys_reg_info").to route_to("merchant_sys_reg_infos#destroy")
    end

  end
end
