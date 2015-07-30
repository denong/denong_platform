require 'rack/test'
FactoryGirl.define do  
  factory :personal_info do
    name "MyString"
    id_card "333333333333333333"
  end
  
  factory :balance_log do
    balance 1.5
  end

  factory :pension_account do
    id_card "MyString"
    state 1
    customer nil
    account "MyString"
  end

  factory :merchant_customer do
    u_id "88888888"
    name "card_name"
    password "abcd.1234"
    jifen 100
  end


  factory :member_card_point_log do
    member_card "MyString"
    point 1.5
    jajin 1.5
  end
  
  factory :pension_log do
    jajin_amount -1
    amount 1.5
  end
 

  factory :agent do
    name "MyString"
    phone "13312345678"
    authentication_token "qwertyuiop"
    email "example_agent@example.com"
    password "abcd.1234"
    contact_person "MyString"
    fax "MyString"
    addr "MyString"
    lat 1.5
    lon 1.5
    sms_token "989898"
  end


  factory :reward_log do
    reward nil
    customer nil
    merchant nil
    amount "MyString"
    float "MyString"
    verify_code "MyString"
    verify_time "2015-06-06 11:28:15"
  end

  factory :reward do
    amount 100
    verify_code "008811"
    max 1
    comment "绑卡送金"
    merchant nil
  end
  
  factory :consume_message do
    title "MyString"
    trade_time "2015-06-05 14:24:53"
    amount 1.5
    merchant nil
  end

  factory :bank_card_info do
    bin "955550"
    bank "招商银行"
    card_type "信用卡"
  end

  factory :thfund_account do
    sn 1
    certification_type 1
    certification_no "MyString"
    name "MyString"
    transaction_time "2015-06-10 20:08:03"
    account_id 1
    mobile "MyString"
    customer nil
    state 1
  end

  factory :ticket do

  end

  factory :topic do
    title "title"
    subtitle "subtitle"
  end

  factory :jajin_verify_log do
    verify_code "123456"
  end

  factory :jajin_identity_code do
    amount 10.8
    verify_code "123456"
    company "万里通积分兑换"
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
    after(:create) do |merchant_message|
      merchant_message.thumb ||= FactoryGirl.create(:image)
    end
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

  factory :merchant_user do
    email "merchant_user@example.com"
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

  factory :customer_reg_info do
    # name    "customer_name"
    # id_card  "333333333"
    nick_name "customer nick name"
    # verify_state "verified"
    gender "male"
    association :image, factory: :image

    factory :verify_customer_reg_info do
      name    "customer_name"
      nick_name "customer nick name"
      gender "male"
      id_card  "333333333"
      verify_state "verified"
      account_state "processing" 
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
        customer.customer_reg_info = create :verify_customer_reg_info
      end
    end

    factory :customer_with_reg_info_jaiin_pension do
      after(:create) do |customer|
        customer.customer_reg_info = create :verify_customer_reg_info
        customer.jajin.update_attributes got: attributes_for(:jajin)[:got]
        create(:pension, customer: customer)
      end
    end
    factory :customer_with_raw_reg_info do |customer|
      after(:create) do |customer|
        customer.customer_reg_info = create :customer_reg_info
      end
    end

    factory :customer_with_ticket do |customer|
      after(:create) do |customer|
        customer.jajin.update_attributes got: attributes_for(:jajin)[:got]
        create(:ticket, customer: customer)
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
      jajin.customer ||= FactoryGirl.create(:customer, jajin: jajin)
    end
  end

  factory :merchant do
    ratio 0.01
    after(:create) do |merchant|
      merchant.sys_reg_info.update_attributes attributes_for(:merchant_sys_reg_info)
      merchant.sys_reg_info.image ||= FactoryGirl.create(:image)
    end
    factory :merchant_with_shops do
      after(:create) do |merchant|
        create_list(:shop, 2, merchant: merchant)
      end
    end
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

    after(:create) do |shop|
      shop.pic ||= FactoryGirl.create(:image)
      shop.logo ||= FactoryGirl.create(:image)
    end
  end

  factory :member_card do
    point 100.88
    user_name "MyString"
    passwd "333333333333333333"
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

  factory :pos_machine do
    acquiring_bank 1
    opertion_time "2015-04-09 20:02:31"
    operator "abcd"
    pos_ind "abcd"
  end
end
