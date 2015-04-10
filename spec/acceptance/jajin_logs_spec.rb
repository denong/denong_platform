require 'acceptance_helper'

resource "获取加金明细" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/jajin_logs" do
    before(:each) do
      customer_with_jajin_pension = create(:customer_with_jajin_pension)
      merchant = create(:merchant)
      create_list(:exchange_log, 3, customer: customer_with_jajin_pension )
      create_list(:tl_trade, 3, customer: customer_with_jajin_pension, merchant: merchant)
      create_list(:given_log, 3, customer: customer_with_jajin_pension)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :jajin_logs, "加金交易记录"
    response_field :id, "交易记录ID"
    response_field :amount, "交易数额"
    response_field :log_time, "记录时间"
    response_field :customer_id, "消费者ID"
    response_field :type, "交易类型"
    response_field :detail, "交易详情"

    example "获取加金明细列表" do
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

  get "/jajin_logs/:id" do
    before(:each) do
      customer_with_jajin_pension = create(:customer_with_jajin_pension)
      merchant = create(:merchant)
      create_list(:exchange_log, 3, customer: customer_with_jajin_pension )
      create_list(:tl_trade, 3, customer: customer_with_jajin_pension, merchant: merchant)
      create_list(:given_log, 3, customer: customer_with_jajin_pension)
    end
    
    merchant_attrs = FactoryGirl.attributes_for(:merchant)

    let(:id) { JajinLog.all.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "交易记录ID"
    response_field :amount, "交易数额"
    response_field :log_time, "记录时间"
    response_field :customer_id, "消费者ID"
    response_field :type, "交易类型"
    response_field :detail, "交易详情"
    
    example "获取加金明细详细信息" do
      do_request
      expect(status).to eq(200)
    end
  end
  

end
