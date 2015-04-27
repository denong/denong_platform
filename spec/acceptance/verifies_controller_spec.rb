require 'acceptance_helper'

resource "通联交易加金领取" do
  get '/verify' do

    # ?ckh=123456789012&date=20150427&time=043503&amt=199.00

    parameter :ckh, "交易参考号", required: true, scope: :verify
    parameter :date, "交易日期", required: true, scope: :verify
    parameter :time, "交易时间", required: true, scope: :verify
    parameter :amt, "交易金额", required: true, scope: :verify

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]


    let(:ckh) { "123456" }
    let(:date) { "123456" }
    let(:time) { "111111" }
    let(:amt) { "100.1" }
    let(:raw_post) { params.to_json }

    example "领取加金成功" do
      do_request
      expect(status).to eq 302
    end
  end
end