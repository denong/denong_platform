require 'acceptance_helper'

resource "用户概要信息查询" do
  header "Accept", "application/json"

  get "/customer_reg_info" do
    before do
      merchant = create(:merchant)
      @user = create(:user)
      bank_cards = create_list(:bank_card, 3)
      @user.customer.bank_cards = bank_cards
      @user.customer.follow! merchant
      @user.customer.customer_reg_info.image = create(:image)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :customer_id, "消费者ID"
    response_field :verify_state, "验证状态【未验证: unverified, 验证中: wait_verify, 已验证:verified 】"
    response_field :id_card, "身份证号码"
    response_field :image, "用户头像"
    response_field :nick_name, "用户昵称"
    response_field :gender, "性别【男: male, 女: female】"
    response_field :pension, "养老金总额"
    response_field :account, "养老金账号"
    response_field :jajin_got, "已验证小金"
    response_field :jajin_unverify, "未验证小金"
    response_field :bank_cards, "银行卡"
    response_field :following_number, "已关注商户数"

    response_field :merchant_id, "商户ID"
    response_field :sys_name, "商户名称"
    response_field :contact_person, "联系人"
    response_field :service_tel, "客服电话"
    response_field :fax_tel, "传真"
    response_field :email, "邮箱"
    response_field :company_addr, "公司地址"
    response_field :region, "地区"
    response_field :postcode, "邮政编码"
    response_field :lon, "经度"
    response_field :lat, "纬度"
    response_field :welcome_string, "欢迎语"
    response_field :comment_text, "备注"
    response_field :votes_up, "赞"
    response_field :giving_jajin, "商户赠送的小金"
    response_field :merchant_image, "商户logo"


    example "获取用户信息成功（自己的信息）" do
      do_request
      expect(status).to eq 200 
    end
  end

  get "/customer_reg_infos/:customer_id" do
    before do
      @customer = create(:customer_with_reg_info)
      create(:friend)
    end

    user_attrs = FactoryGirl.attributes_for(:friend)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    let(:customer_id) { @customer.id }

    response_field :name, "姓名"
    response_field :customer_id, "消费者ID"
    response_field :image, "用户头像"
    response_field :nick_name, "用户昵称"
    response_field :gender, "性别【男: male, 女: female】"

    example "获取用户信息成功（其他用户的信息）" do
      do_request
      expect(status).to eq 200 
    end

  end

  put "/customer_reg_info" do
    before do
      create(:customer_with_reg_info)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :customer_id, "消费者ID"
    response_field :verify_state, "验证状态【未验证: unverified, 验证中: wait_verify, 已验证:verified 】"
    response_field :id_card, "身份证号码"
    response_field :image, "用户头像"
    response_field :nick_name, "用户昵称"
    response_field :gender, "性别【男: male, 女: female】"

    parameter :nick_name, "昵称", scope: :customer_reg_info
    parameter :gender, "性别【男: male, 女: female】", scope: :customer_reg_info
    parameter :image_attributes, "头像", scope: :customer_reg_info

    let(:nick_name) { "Hello world!" }
    let(:gender) { "female" }
    let(:image_attributes) { attributes_for(:image) }

    example "更新用户信息成功" do
      do_request
      expect(status).to eq 200 
    end
  end
end