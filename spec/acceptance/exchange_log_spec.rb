require 'acceptance_helper'

resource "小金转换养老金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/exchange_logs" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :amount, "小金转换养老金的总数", required: true, scope: :exchange_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:amount) { 1.5 }
    let(:raw_post) { params.to_json }

    example "获取养老金成功" do
      do_request
      expect(status).to eq 201
    end
  end

  post "/exchange_logs" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :amount, "小金转换养老金的总数", require: true, scope: :exchange_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:amount) { 200 }
    let(:raw_post) { params.to_json }

    example "小金转换养老金失败（请求总额大于可用小金总额）" do
      do_request
      expect(status).to eq 422
    end
  end

  post "/exchange_logs" do
    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :amount, "小金转换养老金的总数", require: true, scope: :exchange_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    # header "X-User-Phone", user_attrs[:phone]

    let(:amount) { 200 }
    let(:raw_post) { params.to_json }

    example "小金转换养老金失败（用户鉴权失败）" do
      do_request
      expect(status).to eq 401
    end
  end

end