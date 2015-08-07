require 'acceptance_helper'

resource "获取商户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/merchants" do
    before(:each) do
      customer = create(:customer_with_jajin_pension)
      merchants = create_list(:merchant, 3) do |merchant|
        customer.follow! merchant
      end
      merchants.each do |merchant|
        (0..3).each do |i|
          create(:merchant_giving_log, merchant: merchant, amount: merchants.index(merchant), customer: customer)  
        end
      end
      Sunspot.commit
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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"
    response_field :followed, "是否关注该商户"

    response_field :time,  "活动时间"
    response_field :title,  "活动标题"
    response_field :content,  "活动内容"
    response_field :summary,  "备注"
    response_field :url, "外链"
    response_field :thumb, "活动宣传图"


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

    parameter :search, "搜索字段", required: false
    let(:search) { "merchant_sys_name" }
    let(:page) { 1 }
    example "搜索商户名称字段" do
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
          create_list(:merchant_message, 2, merchant: merchant)
        end
        customer.follow! merchant
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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"
    response_field :message, "商户活动"

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取当前用户相关商户信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

  end

  get "/merchant" do
    before(:each) do
      @merchant = create(:merchant)
      @merchant.sys_reg_info = create(:merchant_sys_reg_info)
    end
    
    parameter :id, "商户ID", required: true
    let(:id) { @merchant.id }

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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"
    response_field :ratio, "小金兑换比例"
    response_field :contact_tel, "联系电话"


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
    response_field :image, "商户logo"

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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"

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
    parameter :image_attributes, "图片", required: true, scope: :merchant
    parameter :logo_attributes, "图片", required: true, scope: :merchant

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
    let(:image_attributes) { attributes_for(:image) }
    let(:logo_attributes) { attributes_for(:image) }

    example "修改商户资料" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/merchants/:id/get_followers" do
    before(:each) do
      @merchant_user = create(:merchant_user)
      @merchant = create(:merchant)
      @merchant_user.merchant = @merchant
      @merchant.shops << create(:shop)
      @customer = create(:customer_with_reg_info_jaiin_pension)
      @customer.follow! @merchant
    end

    let(:id) { @merchant.id }

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    example "获取关注商户的消费者" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'merchants/:id/follow' do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant, 2)
    end

    let(:id) { Merchant.last.id }
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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"

    example "关注商户成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'merchants/:id/unfollow' do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant, 2)
    end

    let(:id) { Merchant.last.id }
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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"

    example "取消关注商户成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'merchants/:id/member_cards' do
    before(:each) do
      customer = create(:customer_with_jajin_pension)
      create(:merchant)
    end

    let(:id) { Merchant.last.id }

    parameter :user_name, "用户名", required: true, scope: :merchant
    parameter :passwd, "密码", required: true, scope: :merchant

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :member_cards, "会员卡"
    response_field :id, "会员卡ID"
    response_field :point, "积分分值"
    response_field :user_name, "用户名"

    let(:user_name) { "abcdefg" }
    let(:passwd) { "123456" }
    let(:raw_post) { params.to_json }

    example "绑定会员卡" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/merchants" do
    before(:each) do
      @agent = create(:agent) 
    end

    agent_attrs = FactoryGirl.attributes_for(:agent)
    header "X-User-Token", agent_attrs[:authentication_token]
    header "X-User-Phone", agent_attrs[:phone]

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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"
    response_field :contact_tel, "联系电话"
    response_field :merchant_user_id, "对应的商户用户ID"

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
    # parameter :welcome_string, "欢迎语", required: true, scope: :merchant
    parameter :comment_text, "备注", required: true, scope: :merchant
    parameter :image_attributes, "图片", required: true, scope: :merchant
    parameter :logo_attributes, "图片", required: true, scope: :merchant
    parameter :contact_tel, "联系电话", required: true, scope: :merchant
    parameter :merchant_user_id, "对应的商户用户ID", required: true, scope: :merchant
    parameter :ratio, "小金兑换比例", required: true, scope: :merchant

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
    let(:contact_tel) { "12345678" }
    let(:merchant_user_id) { 8 }
    let(:ratio) { 0.01 }
    let(:image_attributes) { attributes_for(:image) }
    let(:logo_attributes) { attributes_for(:image) }

    example "创建商户" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/merchants" do
    before(:each) do
      @agent = create(:agent) 
    end

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
    response_field :image, "商户大图"
    response_field :logo, "商户logo"
    response_field :contact_tel, "联系电话"
    response_field :merchant_user_id, "对应的商户用户ID"
    response_field :agent_id, "代理商ID"

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
    # parameter :welcome_string, "欢迎语", required: true, scope: :merchant
    parameter :comment_text, "备注", required: true, scope: :merchant
    parameter :image_attributes, "图片", required: true, scope: :merchant
    parameter :logo_attributes, "图片", required: true, scope: :merchant
    parameter :contact_tel, "联系电话", required: true, scope: :merchant
    parameter :merchant_user_id, "对应的商户用户ID", required: true, scope: :merchant
    parameter :ratio, "小金兑换比例", required: true, scope: :merchant
    parameter :agent_id, "代理商ID", required: true, scope: :merchant

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
    let(:contact_tel) { "12345678" }
    let(:merchant_user_id) { 8 }
    let(:ratio) { 0.01 }
    let(:agent_id) { 1 }
    let(:image_attributes) { attributes_for(:image) }
    let(:logo_attributes) { attributes_for(:image) }
    

    example "商户注册" do
      do_request
      expect(status).to eq(200)
    end
  end

end
