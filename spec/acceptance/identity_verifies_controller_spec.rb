require 'acceptance_helper'

resource "用户信息验证" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/identity_verifies" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :name, "用户名称", require: true, scope: :identity_verify
    parameter :id_num, "身份证号码", require: true, scope: :identity_verify

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:name) { "test" }
    let(:id_num) { "13941293487192347" }
    let(:raw_post) { params.to_json }

    example "上传身份证成功" do
      do_request
      expect(status).to eq 200
    end
  end
end