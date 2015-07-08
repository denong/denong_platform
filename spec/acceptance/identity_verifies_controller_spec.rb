require 'acceptance_helper'

resource "用户信息验证" do
  header "Accept", "application/json"

  # post "/identity_verifies" do

  #   before do
  #     FactoryGirl.create(:customer_with_jajin_pension)
  #   end

  #   parameter :name, "用户名称", required: true, scope: :identity_verify
  #   parameter :id_card, "身份证号码", required: true, scope: :identity_verify
  #   parameter :front_image_attributes, "正面照片",required: true, scope: :identity_verify
  #   parameter :back_image_attributes, "反面照片",required: true, scope: :identity_verify


  #   user_attrs = FactoryGirl.attributes_for(:user)

  #   header "X-User-Token", user_attrs[:authentication_token]
  #   header "X-User-Phone", user_attrs[:phone]

  #   response_field :name, "姓名"
  #   response_field :id_card, "身份证号码"
  #   response_field :verify_state, "验证状态"
  #   response_field :front_image, "身份证正面照片"
  #   response_field :back_image, "身份证反面照片"

  #   let(:name) { "test" }
  #   let(:id_card) { "333333333333333333" }
  #   let(:front_image_attributes) { attributes_for(:image) }
  #   let(:back_image_attributes) { attributes_for(:image) }

  #   example "上传身份证成功" do
  #     do_request
  #     expect(status).to eq 200
  #   end

  # end

  # post "/identity_verifies" do
  #   before do
  #     create(:customer_with_jajin_pension)
  #   end

  #   parameter :name, "用户名称", required: true, scope: :identity_verify
  #   parameter :id_card, "身份证号码", required: true, scope: :identity_verify
  #   parameter :front_image_attributes, "正面照片",required: true, scope: :identity_verify
  #   parameter :back_image_attributes, "反面照片",required: true, scope: :identity_verify


  #   user_attrs = FactoryGirl.attributes_for(:user)

  #   header "X-User-Token", user_attrs[:authentication_token]
  #   header "X-User-Phone", user_attrs[:phone]

  #   response_field :name, "姓名"
  #   response_field :id_card, "身份证号码"
  #   response_field :verify_state, "验证状态"
  #   response_field :front_image, "身份证正面照片"
  #   response_field :back_image, "身份证反面照片"

  #   let(:name) { "test" }
  #   # let(:id_card) { "333333333333333333" }
  #   let(:front_image_attributes) { attributes_for(:image) }
  #   let(:back_image_attributes) { attributes_for(:image) }

  #   example "上传身份证失败" do
  #     do_request
  #     expect(status).to eq 422
  #   end
  # end

  get "/identity_verifies" do
    before do
      customer = create(:customer_with_jajin_pension)
      image = create(:image)
      identity = create(:identity_verify, customer: customer, 
        front_image_attributes: attributes_for(:image), 
        back_image_attributes: attributes_for(:image))
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

  put "/identity_verifies/:id" do
    before do
      customer = create(:customer_with_jajin_pension)
      image = create(:image)
      @identity = create(:identity_verify, customer: customer, 
        front_image_attributes: attributes_for(:image), 
        back_image_attributes: attributes_for(:image))

      create(:merchant_user)
    end

    merchant_user_attrs = FactoryGirl.attributes_for(:merchant_user)

    header "X-User-Token", merchant_user_attrs[:authentication_token]
    header "X-User-Phone", merchant_user_attrs[:phone]

    parameter :verify_state, "验证状态",required: true, scope: :identity_verify
    
    let(:id) { @identity.id }
    let(:verify_state) { :verified }
    
    example "审核结果查询成功" do
      do_request
      expect(status).to eq 200
    end
  end
end