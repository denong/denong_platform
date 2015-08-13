require 'acceptance_helper'

resource "查询会员卡积分" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/member_cards/:id" do
    before do
      merchant = create(:merchant)
      customer = create(:customer)
      merchant_customer = create(:merchant_customer)
      create(:personal_info, name: "ABC", id_card: "331726199111111111")
      create(:member_card, merchant: merchant, customer: customer, user_name: "ABC", passwd: "331726199111111111")
    end

    let(:id) { MemberCard.all.last.id }

    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :user_name, "用户名"
    response_field :merchant_name, "商户名"
    response_field :merchant_logo, "商户logo"
    response_field :merchant_giving_jajin, "商户赠送小金数"
    response_field :customer_jajin_total, "商户给当前用户的小金数"
    response_field :total_trans_jajin, "已转换的小金"
    response_field :unconvert_jajin, "可转换的小金"
    response_field :merchant_id, "商户ID"
    response_field :member_card_amount, "该商户已授权的会员卡数量"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

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
      merchant_customer = create(:merchant_customer)
      create(:personal_info, name: "于子洵", id_card: "333333333333333333")
    end

    parameter :merchant_id, "商户ID", required: true, scope: :member_card
    parameter :user_name, "名字", required: true, scope: :member_card
    parameter :passwd, "身份证号", required: true, scope: :member_card

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :merchant_id, "商户ID"
    response_field :customer_id, "消费者ID"
    response_field :member_card_amount, "该商户已授权的会员卡数量"

    let(:merchant_id) { Merchant.all.first.id }
    let(:user_name) { "于子洵" }
    let(:passwd) { "333333333333333333" }
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

      merchant_customer =
      merchants.each do |merchant|
        pi = create(:personal_info, name: "A"+merchants.index(merchant).to_s, id_card: "33172611111110111"+merchants.index(merchant).to_s)
        create(:merchant_customer, u_id: "A"+merchants.index(merchant).to_s, password: "33172611111110111"+merchants.index(merchant).to_s)
        create(:member_card, customer: customer, merchant: merchant, user_name: "A"+merchants.index(merchant).to_s, passwd: "33172611111110111"+merchants.index(merchant).to_s)
      end
    end

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :member_cards, "会员卡"
    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :user_name, "用户名"
    response_field :merchant_name, "商户名"
    response_field :merchant_logo, "商户logo"
    response_field :merchant_giving_jajin, "商户赠送小金数"
    response_field :customer_jajin_total, "商户给当前用户的小金数"
    response_field :total_trans_jajin, "已转换的小金"
    response_field :unconvert_jajin, "可转换的小金"
    response_field :merchant_id, "商户ID"
    response_field :member_card_amount, "该商户已授权的会员卡数量"
    
    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "查询各个会员卡的积分" do
      do_request
      expect(status).to eq 200
    end
  end

  post "/member_cards/check_member_card" do
    before do
      agent = create(:agent)
      @merchant = create(:merchant, agent: agent)
      @customer = create(:customer)
      create(:personal_info, name: "A1", id_card: "331726111111101111")
      create(:member_card, customer: @customer, merchant: @merchant, user_name: "A1", passwd: "331726111111101111")
    end

    parameter :merchant_id, "商户ID", required: true, scope: :member_card
    parameter :phone, "用户手机号", required: true, scope: :member_card

    response_field :exist, "是否存在"
    
    user_attrs = FactoryGirl.attributes_for(:agent)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:merchant_id) { @merchant.id }
    let(:phone) { @customer.user.phone }
    let(:raw_post) { params.to_json }

    example "查询某商户是否存在某用户的会员卡" do
      do_request
      expect(status).to eq 200
    end
  end

end