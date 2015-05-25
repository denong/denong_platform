require 'acceptance_helper'

resource "拍小票送小金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/tickets" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :customer_id, "消费者ID", required: true, scope: :ticket

    response_field :customer_id, "消费者ID"
    response_field :jajin_got, "已验证小金"
    response_field :jajin_unverify, "未验证小金"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:customer_id) { 1 }
    let(:raw_post) { params.to_json }

    example "拍小票送小金成功" do
      do_request
      expect(status).to eq 200
    end
  end

  post "/tickets" do
    before do
      FactoryGirl.create(:customer_with_ticket)
    end

    parameter :customer_id, "消费者ID", required: true, scope: :ticket

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:customer_id) { 1 }
    let(:raw_post) { params.to_json }

    example "拍小票送小金失败（已经领取）" do
      do_request
      expect(status).to eq 422
    end
  end

end