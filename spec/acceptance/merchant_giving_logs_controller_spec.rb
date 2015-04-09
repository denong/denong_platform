require 'acceptance_helper'

resource "商户赠送加金记录" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchant_giving_logs" do
    before(:each) do
      customer = create(:customer)
      merchant = create(:merchant)
      create_list(:merchant_giving_log, 3, customer: customer, merchant: merchant )
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "查询商户赠送用户的加金" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/merchant_giving_logs/:id" do
    before(:each) do
      customer = create(:customer)
      merchant = create(:merchant)
      create_list(:merchant_giving_log, 3, customer: customer, merchant: merchant )
    end

    let(:id) { MerchantGivingLog.all.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]


    parameter :merchant_id, "商户编号", required: true, scope: :merchant_giving_log
    let(:merchant_id) { "1" }

    example "查询该商户赠送该用户的加金" do
      do_request
      expect(status).to eq(200)
    end
  end
  
end
