require 'acceptance_helper'
resource "通联交易记录" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/tl_trades" do
    before(:each) do
      @merchant = create(:merchant)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :card,           "通联卡号"
    response_field :phone,          "手机号"
    response_field :pos_ind,        "POS编号"
    response_field :price,          "金额"
    response_field :shop_ind,       "门店编号"
    response_field :trade_ind,      "交易编号"
    response_field :trade_time,     "交易时间"

    parameter :card, "通联卡号", required: true, scope: :tl_trade
    parameter :phone, "手机号", required: true, scope: :tl_trade
    parameter :pos_ind, "POS编号", required: true, scope: :tl_trade
    parameter :price, "金额", required: true, scope: :tl_trade
    parameter :shop_ind, "门店编号", required: true, scope: :tl_trade
    parameter :trade_ind, "商户编号", required: true, scope: :tl_trade
    parameter :trade_time, "交易时间", required: true, scope: :tl_trade

    let(:card) { "123456789" }
    let(:phone) { "133AAAA3333" }
    let(:pos_ind) { "MyString" }
    let(:price) { 110.01 }
    let(:shop_ind) { "MyString" }
    let(:trade_ind) { "MyString" }
    let(:trade_time) { DateTime.now }
    let(:raw_post) { params.to_json }

    example "创建交易记录" do
      do_request
      expect(status).to eq(201)
    end
  end
end
