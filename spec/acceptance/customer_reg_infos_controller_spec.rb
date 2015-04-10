require 'acceptance_helper'

resource "用户概要信息查询" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/customer_reg_infos/:id" do
    before do
      create(:customer_with_reg_info)
    end

    let(:id) { Customer.first.id}

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :customer_id, "消费者ID"
    response_field :verify_state, "验证状态"
    response_field :idcard, "身份证号码"

    example "获取用户信息成功" do
      do_request
      expect(status).to eq 200 
    end
  end
end