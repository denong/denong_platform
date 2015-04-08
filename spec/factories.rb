require 'rack/test'
FactoryGirl.define do  
  factory :image do
    title "MyString"
    photo_type "MyString"
    photo {Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png')}
  end
  
  
  factory :identity_verify do
    name "ExampleName"
    id_num "333333333333333333"
    verify_state 1
  end

  factory :bank_card do
    bankcard_no "0987654321123456"
    id_card "333333333333333333"
    name "ExampleName"
    phone "12345678901"
    card_type 1
    bank 1
    bind_state 1
    bind_time "2015-04-05 14:15:05"
  end  
  
  factory :exchange_log do
    amount 1.5
  end

  factory :sms_token do
    phone "12345678901"
    token "123456"
  end

  factory :user do
    email "example@example.com"
    phone "12345678901"
    password "abcd.1234"
    sms_token "989898"
    authentication_token "qwertyuiop"
  end

  factory :friend do   #, class: User
    phone "10987654321"
    password "4321.dcba"
    password_confirmation "4321.dcba"
  end

  factory :jajin do
    got 188.88

    after(:build) do |jajin|
      jajin.customer ||= FactoryGirl.create(:customer, :jajin => jajin)
    end
  end

  factory :customer do

    factory :customer_with_jajin_pension do
      after(:create) do |customer|
        customer.jajin.update_attributes got: attributes_for(:jajin)[:got]
        create(:pension, customer: customer)
      end
    end
    factory :customer_with_jajin do
      after(:create) do |customer|
        customer.jajin.update_attributes got: attributes_for(:jajin)[:got]
      end
    end
    factory :customer_with_pension do |customer|
      after(:create) do |customer|
        create(:pension, customer: customer)
      end
    end
    factory :customer_with_reg_info do |customer|
      after(:create) do |customer|
        customer.customer_reg_info.update_attributes attributes_for(:customer_reg_info)
      end
    end

    after(:build) do |customer|
      customer.user ||= FactoryGirl.create(:user, customer: customer)
    end
  end

  factory :pension do
    account "1234567"
    total 88.88

    after(:build) do |pension|
      pension.customer ||= FactoryGirl.create(:customer, pension: pension)
    end
  end

  factory :tl_trade do
    phone "12345678901"
    price 88888
  end

  factory :merchant do
    ratio 0.01
    after(:create) do |merchant|
      merchant.sys_reg_info.update_attributes attributes_for(:merchant_sys_reg_info)
    end
    factory :merchant_with_shops do
      after(:create) do |merchant|
        create_list(:shop, 2, merchant: merchant)
      end
    end
  end

  factory :customer_reg_info do
    name    "customer_name"
    idcard  "333333333"
  end

  factory :merchant_sys_reg_info do
    sys_name       "merchant_sys_name"
    contact_person "merchant_contact_person"
    contact_tel    "09876543211"
    service_tel    "11234567890"
    fax_tel        "021-11111111"
    email          "example@example.com"
    company_addr   "shanghai"
    region         "xuhui"
    industry       "industry_name"
    postcode       "200000"
    lon            "31.10"
    lat            "131.20"
    welcome_string "welcome"
    comment_text   "good"
   end

  factory :shop do
    name "shop_name"
    addr "shop_addr"
    contact_person "shop_contact_person"
    contact_tel "12345678901"
    work_time "9:00-18:00"
  end


end
