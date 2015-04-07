require 'acceptance_helper'

resource "获取门店信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/shops" do
    before(:each) do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    FactoryGirl.create_list(:shop, 2)
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取门店信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

    parameter :page, "页码", scope: :shop
    let(:page) { 3 }
    example "获取门店信息列表二十到三十条" do
      do_request
      expect(status).to eq(200)
    end

  end
end