require 'acceptance_helper'

resource "获取商户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchants" do
    before(:each) do
      create(:customer_with_jajin_pension)
      merchants = create_list(:merchant, 3)
      merchants.each do |merchant|
        (0..3).each do |i|
          create(:merchant_giving_log, merchant: merchant, amount: merchants.index(merchant))  
        end
      end
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
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
    response_field :giving_jajin, "商户赠送的小金"
    
    example "获取商户信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "获取商户信息列表第三页" do
      do_request
      expect(status).to eq(200)
    end
  end


  get "/merchants/customer_index" do
    before(:each) do
      customer = create(:customer)
      merchants = create_list(:merchant, 3)
      merchants.each do |merchant|
        (0..3).each do |i|
          create(:merchant_giving_log, merchant: merchant, amount: merchants.index(merchant), customer: customer)  
        end
      end
    end

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
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
    response_field :giving_jajin, "商户赠送的小金"
    
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取当前用户相关商户信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

  end

  get "/merchants/:id" do
    before(:each) do
      create(:customer_with_jajin_pension)
      create(:merchant)
    end
    
    merchant_attrs = FactoryGirl.attributes_for(:merchant)

    let(:id) { Merchant.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

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
    response_field :giving_jajin, "商户赠送的小金"
    
    example "获取商户详细信息" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/merchants/:id/add_tag" do
    before(:each) do
      @merchant = create(:merchant)  
    end

    let(:id) { @merchant.id }

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    parameter :tags, "标签", required: true, scope: :merchant

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
    response_field :tags, "标签"

    let(:tags) { "good,well,nice" }
    let(:raw_post) { params.to_json }

    example "为商户添加标签" do
      do_request
      expect(status).to eq(200)
    end
  end

  put "/merchants/:id/" do
    before(:each) do
      @merchant_user = create(:merchant_user)
      @merchant = create(:merchant)
      @merchant_user.merchant = @merchant 
    end

    let(:id) { @merchant.id }

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

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
    response_field :tags, "标签"

    parameter :sys_name, "商户名称", required: true, scope: :merchant
    parameter :contact_person, "联系人", required: true, scope: :merchant
    parameter :service_tel, "客服电话", required: true, scope: :merchant
    parameter :fax_tel, "传真", required: true, scope: :merchant
    parameter :email, "邮箱", required: true, scope: :merchant
    parameter :company_addr, "公司地址", required: true, scope: :merchant
    parameter :region, "地区", required: true, scope: :merchant
    parameter :postcode, "邮政编码", required: true, scope: :merchant
    parameter :lon, "经度", required: true, scope: :merchant
    parameter :lat, "纬度", required: true, scope: :merchant
    parameter :welcome_string, "欢迎语", required: true, scope: :merchant
    parameter :comment_text, "备注", required: true, scope: :merchant

    let(:sys_name) { "new_sys_name" }
    let(:contact_person) { "new_contact_person" }
    let(:service_tel) { "new_service_tel" }
    let(:fax_tel) { "new_fax_tel" }
    let(:email) { "new_email" }
    let(:company_addr) { "new_company_addr" }
    let(:region) { "new_region" }
    let(:postcode) { "new_postcode" }
    let(:lon) { 111.111 }
    let(:lat) { 222.222 }
    let(:welcome_string) { "new_welcome_string" }
    let(:comment_text) { "new_comment_text" }

    let(:raw_post) { params.to_json }

    example "修改商户资料" do
      do_request
      expect(status).to eq(200)
    end
  end
end
