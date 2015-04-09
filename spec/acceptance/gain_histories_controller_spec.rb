require 'acceptance_helper'

resource "历史收益" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/gain_histories" do
    before do
      customer = create(:customer)
      create_list(:gain_history, 15, customer: customer)
    end

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "查询历史收益" do
      do_request
      expect(status).to eq 200
    end

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "查询历史收益第三页" do
      do_request
      puts "#{response_body}"
      expect(status).to eq(200)
    end
  end

  get "/gain_histories/:id" do
    before do
      date_times = []
      for i in 1..10 do
        date_times << DateTime.new(2001,2,i.to_i)
      end
      customer = create(:customer)
      date_times.each do |date_time|
        create(:gain_history, gain_date: date_time, customer: customer)
      end
    end

    let(:id) { GainHistory.all.last.id }
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "查询昨日收益" do
      do_request
      expect(status).to eq 200
    end
  end
end