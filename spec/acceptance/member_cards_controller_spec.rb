require 'acceptance_helper'

resource "查询会员卡积分" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/member_cards/:id" do
    before do
      merchant = create(:merchant)
      customer = create(:customer)
      create(:member_card, merchant: merchant, customer: customer)
    end

    let(:id) { MemberCard.all.last.id }
    parameter :merchant_id, "商户ID", required: true

    response_field :point, "积分分值"

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

  post "/member_cards/bind" do
    before do
      merchant = create(:merchant)
      customer = create(:customer)
      create(:member_card)
    end

    parameter :merchant_id, "商户ID", required: true, scope: :member_card
    parameter :user_name, "会员卡用户", required: true, scope: :member_card
    parameter :passwd, "会员卡密码", required: true, scope: :member_card

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :merchant_id, "商户ID"
    response_field :customer_id, "消费者ID"

    let(:merchant_id) { Merchant.all.first.id }
    let(:user_name) { "test_user" }
    let(:passwd) { "test_passwd" }
    let(:raw_post) { params.to_json }

    example "绑定会员卡成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_cards" do
    before do
      merchants = create_list(:merchant, 5)
      customer = create(:customer)
      merchants.each do |merchant|
        create(:member_card, customer: customer, merchant: merchant, user_name: "a"+merchants.index(merchant).to_s)
      end
    end

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :member_cards, "会员卡"
    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :user_name, "用户名"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "查询各个会员卡的积分" do
      do_request
      expect(status).to eq 200
    end
  end
end