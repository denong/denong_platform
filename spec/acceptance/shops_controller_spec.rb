require 'acceptance_helper'

resource "获取门店信息" do
  header "Accept", "application/json"

  get "/shops" do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:shop, 3)
    end
    
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取门店信息列表前十条" do
      do_request
      expect(status).to eq(200)
    end

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"

    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "获取门店信息列表第三页" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/shops/:id" do
    before(:each) do
      create(:customer_with_jajin_pension)
      shop = create(:shop)
      shop.pos_machines = create_list(:pos_machine, 2)
    end
    
    let(:id) { Shop.all.first.id }

    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"

    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    response_field :acquiring_bank, "收单机构"
    response_field :operator, "操作员"
    response_field :opertion_time, "操作时间"
    response_field :shop_id, "门店ID"
    response_field :pos_ind, "POS机编号"

    parameter :page, "POS机页数", required: false

    example "获取指定门店信息第一页" do
      do_request
      expect(status).to eq(200)
    end

    let(:page) { 2 }
    example "获取指定门店信息第二页" do
      do_request
      expect(status).to eq(200)
    end

  end

  get "merchants/:merchant_id/shops"  do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant_with_shops, 2)
    end
    
    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"
    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    let(:merchant_id) { Merchant.last.id }
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取指定商户的门店列表" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'shops/:id/follow' do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant_with_shops, 2)
    end

    let(:id) { Shop.last.id }
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"
    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    example "关注门店成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'shops/:id/unfollow' do
    before(:each) do
      create(:customer_with_jajin_pension)
      create_list(:merchant_with_shops, 2)
    end

    let(:id) { Shop.last.id }
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"
    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    example "取消关注门店成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post 'shops/neighbour_shop' do
    before(:each) do
      create(:customer)
      (0..5).each do |i|
        create(:shop, lon: 30.40+i, lat: 120.51+i)  
      end
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    header "Content-Type", "application/json"

    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"
    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    parameter :lat, "纬度", required: true, scope: :shop
    parameter :lon, "经度", required: true, scope: :shop

    let(:lon) { 32.40 } 
    let(:lat) { 120.51 }
    let(:raw_post) { params.to_json }

    example "获取附近的门店" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "merchants/:merchant_id/shops"  do
    before(:each) do
      @merchant_user = create(:merchant_user)
      @merchant_user.merchant = create(:merchant)
    end
    
    parameter :name, "门店名", required: true, scope: :shop
    parameter :addr, "门店地址", required: true, scope: :shop
    parameter :contact_person, "联系人", required: true, scope: :shop
    parameter :contact_tel, "联系电话", required: true, scope: :shop
    parameter :work_time, "营业时间", required: true, scope: :shop
    parameter :lat, "纬度", required: true, scope: :shop
    parameter :lon, "经度", required: true, scope: :shop
    parameter :pic_attributes, "图片", required: true, scope: :shop
    parameter :logo_attributes, "logo", required: true, scope: :shop

    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
    response_field :pic, "图片"
    response_field :logo, "logo"
    response_field :post_code, "邮编"
    response_field :email, "电子邮箱"
    response_field :service_tel, "客服电话"
    response_field :welcome_text, "欢迎语"
    response_field :remark, "备注"

    let(:merchant_id) { Merchant.last.id }

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)
    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]


    let(:name) { "shop_name" }
    let(:addr) { "shop_addr" }
    let(:contact_person) { "contact_person" }
    let(:contact_tel) { "contact_tel" }
    let(:work_time) { "9:00-16:00" }
    let(:lat) { 33.33 }
    let(:lon) { 131.11 }
    let(:pic_attributes) { attributes_for(:image) }
    let(:logo_attributes) { attributes_for(:image) }
    # let(:raw_post) { params.to_json }

    example "创建门店" do
      do_request
      expect(status).to eq(200)
    end
  end
end