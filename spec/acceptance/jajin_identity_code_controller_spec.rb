require 'acceptance_helper'

resource "生成加金二维码" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/jajin_identity_code" do
    before(:each) do
      merchant = create(:merchant)
      merchant_user = create(:merchant_user, merchant: merchant)
    end

    merchant_user_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_user_attrs[:authentication_token]
    header "X-User-Phone", merchant_user_attrs[:phone]

    parameter :amount, "小金数目", required: true, scope: :jajin_identity_code
    parameter :expiration_time, "过期时间", scope: :jajin_identity_code
    parameter :company, "商户名称" , required: true, scope: :jajin_identity_code

    response_field :amount, "小金数目"
    response_field :expiration_time, "过期时间"
    response_field :company, "商户名称"
    response_field :merchant_id, "商户ID"
    response_field :verify_code, "二维码"
    response_field :verify_state, "验证状态"

    let(:company) { "DeNong" }
    let(:expiration_time) { DateTime.now }
    let(:amount) { 8.88 }
    let(:raw_post) { params.to_json }

    example "生成加金二维码成功" do
      do_request
      expect(status).to eq(200)
    end

  end

end
