json.array!(@merchant_sys_reg_infos) do |merchant_sys_reg_info|
  json.extract! merchant_sys_reg_info, :id
  json.url merchant_sys_reg_info_url(merchant_sys_reg_info, format: :json)
end
