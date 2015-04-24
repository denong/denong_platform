require 'acceptance_helper'

resource "扫码送加金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/jajin_verify_logs" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
      FactoryGirl.create(:jajin_identity_code)
    end

    parameter :verify_code, "加金的验证码", required: true, scope: :jajin_verify_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:verify_code) { "123456" }
    let(:raw_post) { params.to_json }

    example "领取加金成功" do
      do_request
      expect(status).to eq 201
    end
  end

  post "/jajin_verify_logs" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :verify_code, "加金的验证码", required: true, scope: :jajin_verify_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:verify_code) { "12367" }
    let(:raw_post) { params.to_json }

    example "领取加金失败（验证码不正确）" do
      do_request
      expect(status).to eq 422
    end
  end

end