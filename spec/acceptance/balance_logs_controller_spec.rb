require 'acceptance_helper'

resource "商户充值" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/balance_logs" do
    before(:each) do
      @merchant = create(:merchant)
      create(:merchant_user, merchant: @merchant)
    end

    parameter :balance, "充值额度", require: true, scope: :balance_logs

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)

    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    response_field :id, "商户金额相关记录ID"
    response_field :jajin, "小金数量(金额兑换小金时有效)"
    response_field :balance, "充值金额"
    response_field :merchant_id, "商户ID"

    let(:balance) { 200 }
    let(:raw_post) { params.to_json }

    example "商户充值成功" do
      do_request
      expect(status).to eq 200
    end

  end

  post "/balance_logs" do
    before(:each) do
      @merchant = create(:merchant, balance: 300)
      create(:merchant_user, merchant: @merchant)
    end

    parameter :balance, "兑换小金数额", require: true, scope: :balance_logs

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)

    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    response_field :id, "商户金额相关记录ID"
    response_field :jajin, "小金数量(金额兑换小金时有效)"
    response_field :balance, "兑换数额"
    response_field :merchant_id, "商户ID"

    let(:balance) { -200 }
    let(:raw_post) { params.to_json }

    example "商户兑换小金" do
      do_request
      expect(status).to eq 200
    end


  end

  get "/balance_logs" do
    before(:each) do
      @merchant = create(:merchant, balance: 300)
      create(:merchant_user, merchant: @merchant)
      create_list(:balance_log, 5, merchant: @merchant, balance: 100)
      create_list(:balance_log, 5, merchant: @merchant, balance: -80)
    end

    parameter :balance, "兑换小金数额", require: true, scope: :balance_logs

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)

    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    response_field :id, "商户金额相关记录ID"
    response_field :jajin, "小金数量(金额兑换小金时有效)"
    response_field :balance, "兑换数额"
    response_field :merchant_id, "商户ID"

    example "获取商户兑换小金记录" do
      do_request
      expect(status).to eq 200
    end
  end
end