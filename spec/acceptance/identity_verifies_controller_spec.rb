require 'acceptance_helper'

resource "用户信息验证" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/identity_verifies" do

    before do
      FactoryGirl.create(:customer_with_jajin_pension)
      @front_image = FactoryGirl.create(:image, photo_type: "front")
      # @back_image = create(:image, photo_type: "back")
    end

    parameter :name, "用户名称", required: true, scope: :identity_verify
    parameter :id_num, "身份证号码", required: true, scope: :identity_verify
    parameter :front_image, "正面照片",required: true, scope: :identity_verify
    parameter :back_image, "反面照片",required: true, scope: :identity_verify


    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:name) { "test" }
    let(:id_num) { "13941293487192347" }
    let(:front_image) { "[uploaded data]" }
    let(:back_image) { "[uploaded data]" }
    let(:raw_post) { params.to_json }

    example "上传身份证成功" do
      do_request
      # puts "response is #{response_body}"
      expect(status).to eq 200
    end
  end

  get "/identity_verifies" do

    before do
      customer = create(:customer_with_jajin_pension)
      create(:identity_verify, customer: customer)
    end

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "审核结果查询成功" do
      do_request
      expect(status).to eq 200
    end
  end
end