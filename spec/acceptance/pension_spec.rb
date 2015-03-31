require 'acceptance_helper'

resource "查询养老金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/pension" do
    before do
      user = User.create(phone: "138138138138", password: "abcd.1234", sms_token: "989898", authentication_token: "123456")
      customer = user.create_customer
      pension = customer.create_pension(account: 111, total: 10.09)
    end
    header "X-User-Token", "123456"
    header "X-User-Phone", "138138138138"

    example "获取养老金成功" do
      do_request
      expect(status).to eq 200 
      expect(response_body).to eq({ account: "111", total: 10.09 }.to_json)
    end
  end

  get "/pension" do
    before do
      user = User.create(phone: "138138138138", password: "abcd.1234", sms_token: "989898", authentication_token: "123456")
      customer = user.create_customer
      pension = customer.create_pension(account: 111, total: 10.09)
    end
    header "X-User-Token", "1234567"
    header "X-User-Phone", "138138138138"

    example "获取养老金失败（Token不正确）" do
      do_request
      expect(status).to eq 401
    end
  end



end