require 'acceptance_helper'

resource "商户推送消息" do
  header "Accept", "application/json"

  get "/merchant_messages" do
    before(:each) do
      date_times = []
      for i in 1..10 do
        date_times << DateTime.new(2020,2,i)
      end
      @merchant = create(:merchant)
      customer = create(:customer)
      date_times.each do |date_time|
        create(:merchant_message, time: date_time, customer: customer, merchant: @merchant)
      end
    end

    parameter :merchant_id, "商户ID", required: true
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

    let(:merchant_id) { @merchant.id }
    example "用户获取商户推送消息" do
      do_request
      puts response_body
      expect(status).to eq(200)
    end
  end

  post "/merchant_messages" do
    before(:each) do
      @merchant_user = create(:merchant_user)
      @merchant = create(:merchant)
      @merchant_user.merchant = @merchant
    end

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    response_field :merchant_messages, "商户推送消息"
    response_field :id, "消息ID"
    response_field :time, "时间"
    response_field :title, "标题"
    response_field :content, "内容"
    response_field :summary, "摘要"
    response_field :url, "外链"
    response_field :merchant_id, "商户ID"

    parameter :time, "时间", required: true, scope: :merchant_message
    parameter :title, "标题", required: true, scope: :merchant_message
    parameter :content, "内容", required: true, scope: :merchant_message
    parameter :summary, "摘要", required: true, scope: :merchant_message
    parameter :url, "外链", required: true, scope: :merchant_message
    parameter :merchant_id, "商户ID", required: true, scope: :merchant_message
    parameter :thumb_attributes, "图片", required: true, scope: :merchant_message

    let(:time) { DateTime.now }
    let(:title) { "title" }
    let(:content) { "content" }
    let(:summary) { "summary" }
    let(:url) { "url" }
    let(:merchant_id) { @merchant.id }
    let(:thumb_attributes) { attributes_for(:image) }

    example "商户创建推送消息" do
      do_request
      expect(status).to eq(200)
    end
  end
end
