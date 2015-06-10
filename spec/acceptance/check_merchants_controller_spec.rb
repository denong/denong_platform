require 'acceptance_helper'

resource "商户用户密码重置" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/check_merchant/reset" do
    before(:each) do
      merchant = create(:merchant)
      merchant_user = create(:merchant_user, merchant: merchant)
    end

    parameter :phone, "手机号", required: true
    parameter :password, "密码", required: true
    parameter :sms_token, "短信验证码" , required: true

    response_field :authentication_token, "token"
    response_field :phone, "手机号"
    response_field :id, "商户ID"


    let(:phone) { "12345678903" }
    let(:password) { "12345678" }
    let(:sms_token) { "989898" }
    let(:raw_post) { params.to_json }

    example "商户用户密码重置成功" do
      do_request
      expect(status).to eq(200)
    end

  end

end
