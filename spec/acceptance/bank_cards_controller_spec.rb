require 'acceptance_helper'

resource "绑定银行卡" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/bank_cards/send_msg" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :card, "银行卡号", required: true
    parameter :name, "姓名",  required: true
    parameter :phone, "电话号码", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:card) { "12345678899" }
    let(:name) { "张三" }
    let(:phone) { "13333333333" }
    let(:raw_post) { params.to_json }

    example "短信发送成功" do
      do_request
      expect(status).to eq 200
    end
  end

  post "/bank_cards" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :sms_token, "短信验证码", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:sms_token) { "123456" }
    let(:raw_post) { params.to_json }

    example "绑定银行卡成功" do
      do_request
      expect(status).to eq 200
    end
  end
end