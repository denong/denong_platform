require 'acceptance_helper'

resource "绑定银行卡" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/bank_cards" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :card, "银行卡号", required: true
    parameter :name, "姓名",  required: true
    parameter :id_card, "身份证号", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:card) { "6222520358610001" }
    let(:name) { "张三" }
    let(:id_card) { "123456789012345678" }
    let(:raw_post) { params.to_json }

    example "银联绑定银行卡" do
      do_request
      expect(status).to eq 200
    end
  end

  post "/bank_cards/send_msg" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :answer, "手机收到的短信验证码", required: true
    parameter :card, "银行卡号", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:answer) { "123456" }
    let(:card) { "6222520358610001" }
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
    response_field :bank_id, "该银行卡所属银行的ID"
    response_field :bank_card_amount, "该银行卡所属银行已经授权银行卡的数量"

    example "银联短信验证" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/bank_cards" do
    before do
      customer = FactoryGirl.create :customer
      FactoryGirl.create_list :bank_card, 3, customer: customer, stat_code: "00"
    end

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取银行卡列表" do
      do_request
      expect(status).to eq 200
    end
  end

  get '/bank_cards/bank_info' do
    before do
      bank_card_info = FactoryGirl.create :bank_card_info
      customer = FactoryGirl.create :customer
    end

    parameter :bankcard_no, "银行卡的卡号", required: true

    let(:bankcard_no) { "955550912376" }
    let(:raw_post) { params.to_json }

    response_field :bank, "银行信息"
    response_field :card_type, "银行卡的类型"
    response_field :bankcard_no, "银行卡的卡号"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取银行卡的相关信息" do
      do_request
      expect(status).to eq 200
    end
  end
end