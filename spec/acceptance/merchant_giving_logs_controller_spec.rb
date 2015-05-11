require 'acceptance_helper'

resource "商户赠送小金记录" do
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

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :merchant_giving_logs, "商户赠送小金记录"
    response_field :id, "赠送记录ID"
    response_field :amount, "赠送数额"
    response_field :giving_time, "赠送时间"
    response_field :merchant_id, "商户ID"
    response_field :customer_id, "消费者ID"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :type, "赠送类型"

    example "查询商户赠送用户的小金" do
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

    response_field :merchant_giving_logs, "商户赠送小金记录"
    response_field :id, "赠送记录ID"
    response_field :amount, "赠送数额"
    response_field :giving_time, "赠送时间"
    response_field :merchant_id, "商户ID"
    response_field :customer_id, "消费者ID"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :type, "赠送类型"

    parameter :merchant_id, "商户编号", required: true, scope: :merchant_giving_log
    let(:merchant_id) { "1" }

    example "查询该商户赠送该用户的小金" do
      do_request
      expect(status).to eq(200)
    end
  end
  
end
