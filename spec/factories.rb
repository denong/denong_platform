FactoryGirl.define do  
  
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
    customer
    got 188.88
  end

  factory :customer do
    user
    factory :customer_with_jajin_pension do
      after(:create) do |customer|
        create(:jajin, customer: customer)
        create(:pension, customer: customer)
        # create_list(:jajin_logs, 10, customer: customer)
      end
    end
    factory :customer_with_jajin do
      after(:create) do |customer|
        create(:jajin, customer: customer)
      end
    end
    factory :customer_with_pension do |customer|
      after(:create) do |customer|
        create(:pension, customer: customer)
      end
    end
  end

  factory :pension do
    customer
    account "123456"
    total 88.88
  end

end
