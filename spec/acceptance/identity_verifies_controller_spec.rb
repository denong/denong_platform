require 'acceptance_helper'

resource "用户信息验证" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/identity_verifies" do

    before do
      FactoryGirl.create(:customer_with_jajin_pension)
    end

    parameter :name, "用户名称", required: true, scope: :identity_verify
    parameter :id_card, "身份证号码", required: true, scope: :identity_verify
    parameter :front_image, "正面照片",required: true, scope: :identity_verify
    parameter :back_image, "反面照片",required: true, scope: :identity_verify


    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :id_card, "身份证号码"
    response_field :verify_state, "验证状态"
    response_field :front_image, "身份证正面照片"
    response_field :back_image, "身份证反面照片"

    let(:name) { "test" }
    let(:id_card) { "333333333333333333" }
    let(:front_image) { ActionDispatch::Http::UploadedFile.new(tempfile: "./spec/asset/news.png", filename: "news.png", original_filename: "news.png", content_type: "image/png", headers: "Content-Disposition: form-data; name=\"front_image[photo]\"") }
    let(:back_image) { ActionDispatch::Http::UploadedFile.new(tempfile: "./spec/asset/news.png", filename: "news.png", original_filename: "news.png", content_type: "image/png", headers: "Content-Disposition: form-data; name=\"front_image[photo]\"") }
    let(:raw_post) { params.to_json }

    example "上传身份证成功" do
      puts "params is:#{params}"
      do_request
      expect(status).to eq 200
    end

  end

  post "/identity_verifies" do
    before do
      create(:customer_with_jajin_pension)
      create(:identity_verify)
    end

    parameter :name, "用户名称", required: true, scope: :identity_verify
    parameter :id_card, "身份证号码", required: true, scope: :identity_verify
    parameter :front_image, "正面照片",required: true, scope: :identity_verify
    parameter :back_image, "反面照片",required: true, scope: :identity_verify


    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :id_card, "身份证号码"
    response_field :verify_state, "验证状态"
    response_field :front_image, "身份证正面照片"
    response_field :back_image, "身份证反面照片"

    let(:name) { "test" }
    let(:id_card) { "333333333333333333" }
    let(:front_image) { "[uploaded data]" }
    let(:back_image) { "[uploaded data]" }
    let(:raw_post) { params.to_json }

    example "上传身份证失败" do
      do_request
      expect(status).to eq 422
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

    response_field :verify_state, "验证状态"
    
    example "审核结果查询成功" do
      do_request
      expect(status).to eq 200
    end
  end
end