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
    parameter :member_card_id, "会员卡卡号", required: true
    parameter :point, "要兑换的积分分值", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :member_card_id, "会员卡卡号"

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
  
end