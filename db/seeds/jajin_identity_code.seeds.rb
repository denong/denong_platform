(0..50).each do |a|
  JajinIdentityCode.create amount: 1000, verify_state: "unverified", company: "德浓网络扫码送金", merchant_id: 3
end