require 'acceptance_helper'

resource "扫码送小金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/jajin_verify_logs/verify" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
      FactoryGirl.create(:jajin_identity_code, trade_time: "20150505221517")
    end

    parameter :verify_code, "小金的验证码", required: true, scope: :jajin_verify_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:verify_code) { "123456" }
    let(:raw_post) { params.to_json }

    example "领取小金成功" do
      do_request
      expect(status).to eq 201
    end
  end

  post "/jajin_verify_logs/verify" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :verify_code, "小金的验证码", required: true, scope: :jajin_verify_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:verify_code) { "12367" }
    let(:raw_post) { params.to_json }

    example "领取小金失败（验证码不正确）" do
      do_request
      expect(status).to eq 422
    end
  end

end