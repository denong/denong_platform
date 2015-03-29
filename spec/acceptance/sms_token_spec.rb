require 'acceptance_helper'

resource "发送短信验证码" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/sms_tokens" do
    parameter :phone, "发送手机号", :required => true, scope: :sms_token

    let(:phone) { "18616591019" }
    let(:raw_post) { params.to_json }

    example "发送短信验证码" do
      do_request
      expect(status).to eq(201)
    end
  end

end
