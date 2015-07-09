require 'acceptance_helper'

resource "商户[客户]信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/merchant/:id/merchant_customer/verify" do
    
    before do
      customer = create(:customer)
      merchant = create(:merchant)
    end

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :id, "商户ID"
    parameter :name, "客户[手机/姓名/ID]", required: true, scope: :merchant_customer
    parameter :password, "客户密码", required: true, scope: :merchant_customer
    
    response_field :status, "状态"
    response_field :message, "返回信息"
    response_field :customer_point, "绑定成功返回客户积分"

    let(:id) { 1 }
    let(:name) { "Alex" }
    let(:password) { "999999" }
    let(:raw_post) { params.to_json }

    example "用户验证" do
      do_request
      expect(status).to eq(201)
    end
  end
end
