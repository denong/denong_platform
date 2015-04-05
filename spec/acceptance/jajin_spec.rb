require 'acceptance_helper'

resource "查询加金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/jajin" do
    before do
      create(:customer_with_jajin_pension)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    jajin_attrs = FactoryGirl.attributes_for(:jajin)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取加金成功" do
      do_request
      expect(status).to eq 200 
    end
  end

  get "/jajin" do
    before do
      create(:jajin)
    end

    header "X-User-Token", "1234567"
    header "X-User-Phone", "138138138138"

    example "获取加金失败（Token不正确）" do
      do_request
      expect(status).to eq 401
    end
  end
end