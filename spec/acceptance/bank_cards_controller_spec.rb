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
    parameter :mobile, "电话号码", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:card) { "6222520358610001" }
    let(:name) { "张三" }
    let(:mobile) { "15826541234" }
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

    response_field :id, "银行卡ID"
    response_field :bankcard_no, "卡号"
    response_field :name, "姓名"
    response_field :phone, "电话号码"
    response_field :card_type, "银行卡类型"
    response_field :sn, "序列号"
    response_field :bank, "银行"
    response_field :bind_state, "绑定状态"
    response_field :bind_time, "绑定时间"
    response_field :customer_id, "消费者ID"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"

    example "绑定银行卡成功" do
      do_request
      expect(status).to eq 200
    end
  end
end