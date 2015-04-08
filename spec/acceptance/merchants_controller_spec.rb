require 'acceptance_helper'

resource "获取商户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchants" do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant, 30)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取商户信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "获取商户信息列表第三页" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/merchants/:id" do
    before(:each) do
      create(:customer_with_jajin_pension)
      create(:merchant)
    end
    
    merchant_attrs = FactoryGirl.attributes_for(:merchant)

    let(:id) { Merchant.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取商户详细信息" do
      do_request
      expect(status).to eq(200)
    end
  end
  

end
