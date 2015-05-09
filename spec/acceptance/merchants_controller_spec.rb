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
    response_field :giving_jajin, "商户赠送的加金"
    
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
    response_field :giving_jajin, "商户赠送的加金"
    
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
    response_field :giving_jajin, "商户赠送的加金"
    
    example "获取商户详细信息" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/merchants/:id/add_tag" do
    before(:each) do
      @merchant = FactoryGirl.create(:merchant)
    end

    let(:id) { @merchant.id }

    parameter :tags, "标签", required: true, scope: :merchant

    let(:tags) { ["good","well","nice"].to_s }
    let(:raw_post) { params.to_json }

    example "为商户添加标签" do
      do_request
      expect(status).to eq(200)
    end
  end
end
