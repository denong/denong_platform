require 'acceptance_helper'

resource "商户推送消息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchant_messages" do
    before(:each) do
      date_times = []
      for i in 1..10 do
        date_times << DateTime.new(2020,2,i)
      end
      merchant = create(:merchant)
      customer = create(:customer)
      date_times.each do |date_time|
        create(:merchant_message, time: date_time, customer: customer, merchant: merchant)
      end
    end

    parameter :last_time, "上次收到消息的时间", required: true
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :merchant_messages, "商户推送消息"
    response_field :id, "消息ID"
    response_field :time, "时间"
    response_field :title, "标题"
    response_field :content, "内容"
    response_field :summary, "摘要"
    response_field :url, "外链"
    response_field :merchant_id, "商户ID"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :customer_id, "消费者ID"

    let(:last_time) { DateTime.now }
    example "用户获取商户推送消息" do
      do_request
      expect(status).to eq(200)
    end
  end
end
