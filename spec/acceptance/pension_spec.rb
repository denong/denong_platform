require 'acceptance_helper'

resource "查询养老金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/pension" do
    before do
      create(:pension)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    pension_attrs = FactoryGirl.attributes_for(:pension)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取养老金成功" do
      do_request
      expect(status).to eq 200 
      expect(response_body).to eq(pension_attrs.to_json)
    end
  end

  get "/pension" do
    before do
      create(:pension)
    end

    header "X-User-Token", "1234567"
    header "X-User-Phone", "138138138138"

    example "获取养老金失败（Token不正确）" do
      do_request
      expect(status).to eq 401
    end
  end
end