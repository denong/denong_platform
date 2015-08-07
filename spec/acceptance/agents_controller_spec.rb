require 'acceptance_helper'

resource "代理商" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  put "/agent" do
    before(:each) do
      create(:agent)
    end

    parameter :phone, "代理商注册的手机号码", required: true, scope: :agent
    parameter :password, "代理商注册的密码", required: true, scope: :agent
    parameter :contact_person, "联系人",required: true, scope: :agent
    parameter :email, "邮箱", required: true, scope: :agent
    parameter :name, "代理商的名字", required: true, scope: :agent

    agent_attrs = FactoryGirl.attributes_for(:agent)
    header "X-User-Token", agent_attrs[:authentication_token]
    header "X-User-Phone", agent_attrs[:phone]

    let(:contact_person) { "new_abcd" }
    let(:name) { "new_agent_name" }
    let(:email) { "new_abcd@abcd.com" }
    let(:phone) { "11111111111" }
    let(:password) { "password" }
    let(:raw_post) { params.to_json }

    response_field :id, "代理商ID"
    response_field :contact_person, "联系人"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :name, "代理商的名字"
    response_field :authentication_token, "鉴权Token"

    example "代理商更新成功" do
      do_request
      expect(status).to eq(200)
    end
  end
end