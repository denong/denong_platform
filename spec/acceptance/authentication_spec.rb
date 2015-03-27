require 'acceptance_helper'

resource "用户鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/users" do
    parameter :phone, "Employee phone", :required => true, scope: :user
    parameter :password, "Employee password", :required => true, scope: :user

    let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    example "用户注册" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do
    before do
      User.create(phone: "138138138138", password: "abcd.1234")
    end

    parameter :phone, "Employee phone", :required => true, scope: :user
    parameter :password, "Employee password", :required => true, scope: :user
    let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    example "用户登录成功" do

      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do

    parameter :phone, "Employee phone", :required => true, scope: :user
    parameter :password, "Employee password", :required => true, scope: :user

    # let(:phone) { "138138138138" }
    let(:password) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    example "用户登录失败" do
      do_request
      expect(status).to eq(401)
    end
  end
end
