if @customer_reg_info.present?
  json.exist true
else
  json.exist false
end