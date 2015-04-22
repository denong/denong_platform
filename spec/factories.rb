require 'rack/test'
FactoryGirl.define do  

  factory :jajin_identity_code do
    expiration_time "2015-04-09 20:02:31"
  end
  
  factory :merchant_giving_log do
    amount 1.5
    giving_time "2015-04-09 20:02:31"
  end
  
  factory :merchant_message do
    time "2015-04-09 18:39:41"
    title "MyString"
    content "MyString"
    summary "MyString"
    url "MyString"
  end
  
  factory :yl_trade do
    trade_time "2015-04-09 17:13:03"
    log_time "2015-04-09"
    trade_currency "MyString"
    trade_state "MyString"
    gain 1.5
    expend 1.5
    merchant_ind "MyString"
    pos_ind "MyString"
    merchant_name "MyString"
    merchant_type "MyString"
    merchant_city "MyString"
    trade_type "MyString"
    trade_way "MyString"
    merchant_addr "MyString"
    card "123456789"
  end
  
  factory :gain_history do
    gain 1.5
    gain_date "2015-04-09 16:24:06"
  end
  

  factory :image do
    title "MyString"
    photo {Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png')}
  end  
  
  factory :identity_verify do
    name "ExampleName"
    id_card "333333333333333333"
    verify_state 1
  end

  factory :bank_card do
    sequence(:bankcard_no) { |n| "0987654321123456#{n}" }
    id_card "333333333333333333"
    name "ExampleName"
    phone "12345678903"
    card_type 1
    bank 1
    bind_state 1
    bind_time "2015-04-05 14:15:05"
  end  
  
  factory :exchange_log do
    amount 1.5
  end

  factory :tl_trade do
    card "12345678"
    price 888.88
    phone "12345678901"
  end

  factory :given_log do
    amount    10
  end

  factory :sms_token do
    phone "12345678903"
    token "123456"
  end

  factory :user do
    email "exampl_user@example.com"
    phone "12345678903"
    password "abcd.1234"
    sms_token "989898"
    authentication_token "qwertyuiop"
  end

  factory :friend, class: User do   #
    email "given_user@example.com"
    phone "13888888888"
    password "abcd.1234"
    sms_token "989898"
    authentication_token "qwertyuioq"  
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

  factory :jajin do
    got 188.88

    after(:build) do |jajin|
      jajin.customer ||= FactoryGirl.create(:customer, :jajin => jajin)
    end
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
    id_card  "333333333"
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
    lon 120.51
    lat 30.40
  end

  factory :member_card do
    point 100.88
  end

  factory :gain_org do
    factory :gain_org_tianhong do
      title "天弘基金"
      sub_title "商家信息商家信息"
      association :thumb, factory: :image
    end

    factory :gain_org_gonghang do
      title "工商银行"
      sub_title "商家信息商家信息"
      association :thumb, factory: :image
    end
  end

  factory :gain_account do
    total 200.5

    factory :gain_account_tianhong do
      association :gain_org, factory: :gain_org_tianhong
    end

    factory :gain_account_gonghang do
      association :gain_org, factory: :gain_org_gonghang
    end
  end

end
