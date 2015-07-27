json.array!(@jajin_identity_codes) do |jajin_identity_code|
  json.extract! jajin_identity_code, :id, :jajin, :balance, :merchant_id
end