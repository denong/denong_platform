require 'acceptance_helper'

resource "专题相关" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/topics" do

    parameter :title, "标题", required: true, scope: :topic
    parameter :subtitle, "副标题", required: true, scope: :topic
    parameter :pic_attributes, "图片",required: true, scope: :topic

    response_field :title, "标题"
    response_field :subtitle, "副标题"
    response_field :pic, "图片"

    let(:title) { "title" }
    let(:subtitle) { "subtitle" }
    let(:pic_attributes) { attributes_for(:image) }

    example "创建专题成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/topics/:id/add_merchant" do

    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @merchant = FactoryGirl.create(:merchant)
    end

    parameter :merchant_id, "商户ID", required: true, scope: :topic
    # response_field :title, "标题"
    # response_field :subtitle, "副标题"
    # response_field :pic, "图片"

    let(:id) { @topic.id }
    let(:merchant_id) { @merchant.id }
    let(:raw_post) { params.to_json }

    example "添加商户成功" do
      do_request
      # puts "response is #{response_body}"
      expect(status).to eq(200)
    end
  end

end