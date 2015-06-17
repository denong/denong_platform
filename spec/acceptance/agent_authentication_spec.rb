require 'acceptance_helper'

resource "代理商鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/agents" do
    parameter :phone, "代理商注册的手机号码", required: true, scope: :agent
    parameter :password, "代理商注册的密码", required: true, scope: :agent

    agent_attrs = FactoryGirl.attributes_for :agent

    let(:phone) { agent_attrs[:phone] }
    let(:password) { agent_attrs[:password] }
    let(:raw_post) { params.to_json }

    response_field :id, "代理商ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "代理商注册成功" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/agents/sign_in" do
    before do
      @agent = create(:agent)
    end

    parameter :phone, "代理商登录的手机号码", required: true, scope: :agent
    parameter :password, "代理商登录密码", required: true, scope: :agent

    agent_attrs = FactoryGirl.attributes_for :agent
    let(:phone) { agent_attrs[:phone] }
    let(:password) { agent_attrs[:password] }
    let(:raw_post) { params.to_json }

    response_field :id, "代理商ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "代理商登录成功" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/agents/sign_in" do

    parameter :phone, "代理商登录的手机号码", required: true, scope: :agent
    parameter :password, "代理商登录的密码", required: true, scope: :agent

    agent_attrs = FactoryGirl.attributes_for :agent
    let(:password) { agent_attrs[:password] }
    let(:raw_post) { params.to_json }

    example "代理商登录失败" do
      do_request
      expect(status).to eq(401)
    end
  end
end
