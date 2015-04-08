require 'acceptance_helper'

resource "查询会员卡积分" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/member_cards/:customer_id" do
    before do
      merchant = create(:merchant)
      customer = create(:customer)
      create(:member_card, merchant: merchant, customer: customer)
    end

    let(:customer_id) { Customer.all.first.id }
    parameter :merchant_id, "商户ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:merchant_id) { Merchant.all.first.id }
    let(:raw_post) { params.to_json }

    example "查询会员卡积分成功" do
      do_request
      expect(status).to eq 200
    end
  end
end