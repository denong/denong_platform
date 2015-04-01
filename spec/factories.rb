FactoryGirl.define do  
  
  factory :exchange_log do
    customer
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

  factory :customer do
    user
  end

  factory :pension do
    account "123456"
    total 88.88
    customer
  end

end
