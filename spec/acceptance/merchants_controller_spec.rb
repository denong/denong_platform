require 'acceptance_helper'

resource "获取商户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  # get "/merchants" do
  #   before(:each) do
  #     FactoryGirl.create(:customer_with_jajin_pension)
  #   end

  #   FactoryGirl.create_list(:merchant, 1)

  #   user_attrs = FactoryGirl.attributes_for(:user)
  #   header "X-User-Token", user_attrs[:authentication_token]
  #   header "X-User-Phone", user_attrs[:phone]

  #   example "获取商户信息列表前十条" do
  #     do_request
  #     expect(status).to eq(200)
  #   end

  #   parameter :page, "页码", scope: :merchant
  #   let(:page) { 3 }
  #   example "获取商户信息列表二十到三十条" do
  #     do_request
  #     expect(status).to eq(200)
  #   end

  #   # let(:page) { 10 }
  #   # example "获取商户信息列表二十到三十条" do
  #   #   do_request
  #   #   expect(status).to eq(200)
  #   # end
  # end

  get "/merchants/:id" do
    before(:each) do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    FactoryGirl.create(:merchant)
    merchant_attrs = FactoryGirl.attributes_for(:merchant)


    let(:id) { merchant_attrs[:id] }
    # puts "#{merchant_attrs}"

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取商户详细信息" do
      do_request
      # puts "response is #{response_body}"
      expect(status).to eq(200)
    end
  end
  

end
