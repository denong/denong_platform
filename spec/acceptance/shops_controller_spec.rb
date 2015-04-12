require 'acceptance_helper'

resource "获取门店信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/shops" do
    before(:each) do
      FactoryGirl.create(:customer_with_jajin_pension)
      FactoryGirl.create_list(:shop, 3)
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

    parameter :page, "页码", required: false
    let(:page) { 3 }
    example "获取门店信息列表第三页" do
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

    response_field :id, "门店ID"
    response_field :name, "门店名"
    response_field :addr, "门店地址"
    response_field :contact_person, "联系人"
    response_field :contact_tel, "联系电话"
    response_field :work_time, "营业时间"
    response_field :votes_up, "赞"
    response_field :lat, "纬度"
    response_field :lon, "经度"
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

end