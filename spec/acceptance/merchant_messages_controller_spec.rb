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

    let(:last_time) { DateTime.now }
    example "用户获取商户推送消息" do
      do_request
      expect(status).to eq(200)
    end
  end
end
