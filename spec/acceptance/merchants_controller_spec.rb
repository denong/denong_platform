require 'acceptance_helper'

resource "获取用户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchants" do
    before(:each) do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    FactoryGirl.create_list(:merchant, 25)
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    # let(:phone) { "138138138138" }
    # let(:password) { "abcd.1234" }
    # let(:raw_post) { params.to_json }

    example "商户用户注册" do
      do_request
      expect(status).to eq(200)
    end
  end
end