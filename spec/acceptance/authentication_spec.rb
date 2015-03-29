require 'acceptance_helper'

resource "用户鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/users" do
    parameter :phone, "用户注册的手机号码", :required => true, scope: :user
    parameter :password, "用户注册的密码", :required => true, scope: :user
    parameter :sms_token, "用户注册的短消息验证码", :required => true, scope: :user

    let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:sms_token) { "123456" }
    let(:raw_post) { params.to_json }

    example "用户注册成功" do
      SmsToken.create(phone: "138138138138", token: "123456")
      do_request
      expect(status).to eq(201)
    end

    example "用户注册失败（短信验证码错误）" do
      SmsToken.create(phone: "138138138138", token: "654321")
      do_request
      expect(status).to eq(422)
    end

    example "用户注册失败（短信验证码不存在）" do
      SmsToken.create(phone: "138138138138", token: "654321")
      do_request
      expect(status).to eq(422)
    end
  end

  post "/users/sign_in" do
    before do
      User.create(phone: "138138138138", password: "abcd.1234", sms_token: "989898")
    end

    parameter :phone, "用户登录的手机号码", :required => true, scope: :user
    parameter :password, "用户登录密码", :required => true, scope: :user
    let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    example "用户登录成功" do

      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do

    parameter :phone, "用户登录的手机号码", :required => true, scope: :user
    parameter :password, "用户登录的密码", :required => true, scope: :user

    # let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    example "用户登录失败" do
      do_request
      expect(status).to eq(401)
    end
  end
end
