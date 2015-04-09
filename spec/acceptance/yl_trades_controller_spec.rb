require 'acceptance_helper'

resource "银联交易记录" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/yl_trades" do
    before(:each) do
      customer_with_jajin_pension = create(:customer_with_jajin_pension)
      merchant = create(:merchant)
      create_list(:yl_trade, 3, customer: customer_with_jajin_pension, merchant: merchant )
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取当前用户的交易记录" do
      do_request
      expect(status).to eq(200)
    end
  end

  # get "/yl_trades/:id" do
  #   before(:each) do
  #     customer_with_jajin_pension = create(:customer_with_jajin_pension)
  #     merchant = create(:merchant)
  #     create_list(:yl_trade, 3, customer: customer_with_jajin_pension, merchant: merchant )
  #   end

  #   let(:id) { YlTrades.all.first.id }

  #   user_attrs = FactoryGirl.attributes_for(:user)
  #   header "X-User-Token", user_attrs[:authentication_token]
  #   header "X-User-Phone", user_attrs[:phone]

  #   let(:card) { "0987654321" }

  #   example "获取指定银联卡的交易记录" do
  #     do_request
  #     expect(status).to eq(200)
  #   end
  # end
  
end
