require 'acceptance_helper'

resource "积分转小金记录" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/member_card_point_log" do
    before do
      create(:user)
      merchant_customer = create(:merchant_customer)
      @member_card = create(:member_card)
    end

    let(:id) { MemberCard.all.last.id }
    parameter :member_card_id, "会员卡ID", required: true
    parameter :point, "要兑换的积分分值", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :member_card_id, "会员卡ID"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:member_card_id) { @member_card.id }
    let(:point) { -50 }
    let(:raw_post) { params.to_json }

    example "会员卡积分转小金成功" do
      do_request
      expect(status).to eq 200
    end
  end
  
  get "/member_card_point_log" do
    before do
      customer = create(:customer_with_jajin_pension)

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      member_cards = []
      member_cards << create(:member_card, customer: customer)
      member_cards << create(:member_card, user_name: "77777777", customer: customer)

      member_cards.each do |member_card|
        create(:member_card_point_log, member_card: member_card, point: -100, customer: customer)
      end
    end

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :page, "页码", required: false

    example "获取积分转小金全部记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log" do
    before do
      customer = create(:customer_with_jajin_pension)

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      member_cards = []
      member_cards << create(:member_card, customer: customer)
      member_cards << create(:member_card, user_name: "77777777", customer: customer)

      member_cards.each do |member_card|
        (0..1).each do |index|
          create(:member_card_point_log, member_card: member_card, point: -50, customer: customer)
        end
      end
    end

    let(:member_card_id) { MemberCard.last.id }

    parameter :page, "页码", required: false
    parameter :member_card_id, "会员卡ID", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取单张积分卡的积分转小金记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log/:id" do
    before do
      customer = create(:customer_with_jajin_pension)

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      member_cards = []
      member_cards << create(:member_card, customer: customer)
      member_cards << create(:member_card, user_name: "77777777", customer: customer)

      member_cards.each do |member_card|
        create(:member_card_point_log, member_card: member_card, point: -100, customer: customer)
      end
    end

    let(:id) { MemberCardPointLog.last.id }

    parameter :member_card_id, "会员卡ID", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取一条积分转小金记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

end