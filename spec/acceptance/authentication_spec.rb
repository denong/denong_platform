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
      create :user
    end

    parameter :phone, "用户登录的手机号码", required: true, scope: :user
    parameter :password, "用户登录密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

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
end
