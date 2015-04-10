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

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :id, "银联交易记录ID"
    response_field :trade_time, "交易时间"
    response_field :trade_currency, "交易币种"
    response_field :trade_state, "交易状态"
    response_field :gain, "收"
    response_field :expend, "支"
    response_field :merchant_ind, "商户编号"
    response_field :pos_ind, "POS编号"
    response_field :merchant_name, "商户名字"
    response_field :merchant_type, "商户类型"
    response_field :merchant_city, "商户所在城市"
    response_field :trade_type, "交易类型"
    response_field :trade_way, "交易途径"
    response_field :merchant_addr, "商户地址"
    response_field :customer_id, "消费者ID"
    response_field :merchant_id, "商户ID"
    response_field :card, "银联卡号"

    example "获取当前用户的交易记录" do
      do_request
      expect(status).to eq(200)
    end

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "获取当前用户的交易记录第三页" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/yl_trades/:id" do
    before(:each) do
      customer_with_jajin_pension = create(:customer_with_jajin_pension)
      merchant = create(:merchant)
      create_list(:yl_trade, 3, customer: customer_with_jajin_pension, merchant: merchant )
    end

    let(:id) { YlTrade.all.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "银联交易记录ID"
    response_field :trade_time, "交易时间"
    response_field :trade_currency, "交易币种"
    response_field :trade_state, "交易状态"
    response_field :gain, "收"
    response_field :expend, "支"
    response_field :merchant_ind, "商户编号"
    response_field :pos_ind, "POS编号"
    response_field :merchant_name, "商户名字"
    response_field :merchant_type, "商户类型"
    response_field :merchant_city, "商户所在城市"
    response_field :trade_type, "交易类型"
    response_field :trade_way, "交易途径"
    response_field :merchant_addr, "商户地址"
    response_field :customer_id, "消费者ID"
    response_field :merchant_id, "商户ID"
    response_field :card, "银联卡号"

    parameter :card, "银联卡号", required: true, scope: :yl_trade
    let(:card) { "123456789" }

    example "获取指定银联卡的交易记录" do
      do_request
      expect(status).to eq(200)
    end
  end
  
end
