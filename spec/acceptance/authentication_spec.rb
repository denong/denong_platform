require 'acceptance_helper'

resource "用户鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/users" do
    parameter :phone, "用户注册的手机号码", required: true, scope: :user
    parameter :password, "用户注册的密码", required: true, scope: :user
    parameter :sms_token, "用户注册的短消息验证码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { sms_attrs[:token] }
    let(:raw_post) { params.to_json }

    response_field :id, "消费者ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "用户注册成功" do
      create :sms_token
      do_request
      expect(status).to eq(201)
    end

    example "用户注册失败（短信验证码错误）" do
      create :sms_token, token: "654321"
      do_request
      expect(status).to eq(422)
    end

    example "用户注册失败（短信验证码不存在）" do
      do_request
      expect(status).to eq(422)
    end
  end

  post "/users/sign_in" do
    before do
      merchant = create(:merchant)
      @user = create(:user)
      bank_cards = create_list(:bank_card, 3)
      @user.customer.bank_cards = bank_cards
      @user.customer.follow! merchant
    end

    parameter :phone, "用户登录的手机号码", required: true, scope: :user
    parameter :password, "用户登录密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

    response_field :id, "消费者ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"
    response_field :pension, "养老金"
    response_field :account, "养老金账号"
    response_field :jajin, "小金"
    response_field :bank_cards, "银行卡卡号"
    response_field :image, "头像"
    response_field :nick_name, "昵称"
    response_field :name, "姓名"
    response_field :gender, "性别"
    response_field :following_ids, "关注商户的ID"
    response_field :following_number, "关注商户的数量"

    example "用户登录成功" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do

    parameter :phone, "用户登录的手机号码", required: true, scope: :user
    parameter :password, "用户登录的密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

    example "用户登录失败" do
      do_request
      expect(status).to eq(401)
    end
  end

  get "/check_user" do

    parameter :phone, "用户注册的手机号码"

    response_field :exists, "用户是否已经注册"

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }

    example "用户已经注册" do
      create :user
      do_request
      expect(status).to eq(200)
      expect(response_body).to eq({exists: true}.to_json)
    end

    example "用户未注册" do
      do_request
      expect(status).to eq(200)
      expect(response_body).to eq({exists: false}.to_json)
    end

  end
end
