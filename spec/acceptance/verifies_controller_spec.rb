require 'acceptance_helper'

resource "通联交易加金领取" do
  get '/verify' do
    header "Accept", "application/json"
    header "Content-Type", "application/json"

    before do
      FactoryGirl.create(:user)
      @jajin_identity_code = FactoryGirl.create(:jajin_identity_code, trade_time: "20150505221517")
    end

    response_field :amount,         "金额"
    response_field :verify_time,    "验证时间"
    response_field :customer_id,    "消费者ID"
    response_field :merchant_id,    "商户ID"
    response_field :verify_code,    "验证码"

    parameter :ckh, "交易参考号", required: true, scope: :verify
    parameter :date, "交易日期", required: true, scope: :verify
    parameter :time, "交易时间", required: true, scope: :verify
    parameter :amt, "交易金额", required: true, scope: :verify

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:ckh) { "123456" }
    let(:date) { "20150505" }
    let(:time) { "221517" }
    let(:amt) { "10.8" }
    let(:raw_post) { params.to_json }

    example "领取加金成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get '/verify' do
    header "Accept", "application/json"
    header "Content-Type", "application/json"

    before do
      FactoryGirl.create(:user)
      @jajin_identity_code = FactoryGirl.create(:jajin_identity_code)
    end

    response_field :amount,         "金额"
    response_field :verify_time,    "验证时间"
    response_field :customer_id,    "消费者ID"
    response_field :merchant_id,    "商户ID"
    response_field :verify_code,    "验证码"

    parameter :ckh, "交易参考号", required: true, scope: :verify
    parameter :date, "交易日期", required: true, scope: :verify
    parameter :time, "交易时间", required: true, scope: :verify
    parameter :amt, "交易金额", required: true, scope: :verify

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:ckh) { "123459" }
    let(:date) { @jajin_identity_code.created_at.strftime("%Y%m%d") }
    let(:time) { @jajin_identity_code.created_at.strftime("%H%M%S") }
    let(:amt) { "10.8" }
    let(:raw_post) { params.to_json }

    example "领取加金失败（交易参考号不匹配）" do
      do_request
      expect(status).to eq 200
    end
  end
end