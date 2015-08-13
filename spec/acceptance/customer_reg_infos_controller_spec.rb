require 'acceptance_helper'

resource "用户概要信息查询" do
  header "Accept", "application/json"

  get "/customer_reg_info" do
    before do
      merchant = create(:merchant)
      @user = create(:user)
      bank = create(:bank)
      bank_cards = create_list(:bank_card, 3, bank_id:bank.id, bank_card_type: 0)
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

  get "/customer_reg_infos/verify_state" do
    before do
      @agent = create(:agent)
      merchant = create(:merchant)
      @user = create(:user)
      bank = create(:bank)
      bank_cards = create_list(:bank_card, 3, bank_id:bank.id, bank_card_type: 0)
      @user.customer.bank_cards = bank_cards
      @user.customer.follow! merchant
      @user.customer.customer_reg_info.image = create(:image)
    end

    user_attrs = FactoryGirl.attributes_for(:agent)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :phone, "手机号", scope: :customer_reg_info

    response_field :exist, "是否存在"

    let(:phone) { @user.phone }

    example "获取用户实名制验证状态成功" do
      do_request
      expect(status).to eq 200 
    end
  end
end