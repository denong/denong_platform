json.array!(@customer_reg_infos) do |customer_reg_info|
  json.extract! customer_reg_info, :id
  json.url customer_reg_info_url(customer_reg_info, format: :json)
end
