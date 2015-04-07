FactoryGirl.define do  
  factory :image do
    title "MyString"
    photo_type "MyString"
    imageable nil
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
  end
end
