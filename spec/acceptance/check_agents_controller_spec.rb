require 'acceptance_helper'

resource "代理商密码重置" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/check_agent/reset" do
    before(:each) do
      @agent = create(:agent)
    end

    parameter :phone, "手机号", required: true
    parameter :password, "密码", required: true
    parameter :sms_token, "短信验证码" , required: true

    response_field :authentication_token, "token"
    response_field :phone, "手机号"
    response_field :id, "代理商ID"

    agent_attrs = FactoryGirl.attributes_for(:agent)
    let(:phone) { agent_attrs[:phone] }
    let(:password) { "abcdefg" }
    let(:sms_token) { "989898" }
    let(:raw_post) { params.to_json }

    example "代理商密码重置成功" do
      do_request
      expect(status).to eq(200)
    end

  end

end
