require 'acceptance_helper'

resource "专题相关" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/topics" do

    parameter :title, "标题", required: true, scope: :topic
    parameter :subtitle, "副标题", required: true, scope: :topic
    parameter :pic_attributes, "图片",required: true, scope: :topic
    parameter :tags, "标签", required: true, scope: :topic

    response_field :title, "标题"
    response_field :subtitle, "副标题"
    response_field :pic, "图片"
    response_field :tags, "标签"

    let(:title) { "title" }
    let(:subtitle) { "subtitle" }
    let(:tags) { "a,b,c" }
    let(:pic_attributes) { attributes_for(:image) }

    example "创建专题成功" do
      do_request
      puts "response is #{response_body}"
      expect(status).to eq(200)
    end
  end

  post "/topics/:id/add_merchant" do

    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @merchant = FactoryGirl.create(:merchant)
    end

    parameter :merchant_id, "商户ID", required: true, scope: :topic

    response_field :title, "标题"
    response_field :subtitle, "副标题"
    response_field :pic, "图片"
    response_field :sys_name, "商户名称"
    response_field :contact_person, "联系人"
    response_field :service_tel, "客服电话"
    response_field :fax_tel, "传真"
    response_field :email, "邮箱"
    response_field :company_addr, "公司地址"
    response_field :region, "地区"
    response_field :postcode, "邮政编码"
    response_field :lon, "经度"
    response_field :lat, "纬度"
    response_field :welcome_string, "欢迎语"
    response_field :comment_text, "备注"
    response_field :votes_up, "赞"

    let(:id) { @topic.id }
    let(:merchant_id) { @merchant.id }
    let(:raw_post) { params.to_json }

    example "添加商户成功" do
      do_request
      # puts "response is #{response_body}"
      expect(status).to eq(200)
    end
  end

  # post "/topics/:id/add_tag" do
  #   before(:each) do
  #     @topic = FactoryGirl.create(:topic)
  #     @merchant = FactoryGirl.create(:merchant)
  #     @merchant.tag_list.add("good","well")
  #     @merchant.save
  #   end

  #   let(:id) { @topic.id }

  #   parameter :tags, "标签", required: true, scope: :topic
    
  #   response_field :title, "标题"
  #   response_field :subtitle, "副标题"
  #   response_field :pic, "图片"
  #   response_field :tags, "标签"

  #   let(:tags) { ["good","well","nice"].to_s }
  #   let(:raw_post) { params.to_json }



  #   example "为主题添加标签" do
  #     do_request
  #     expect(status).to eq(200)
  #   end

  # end
end