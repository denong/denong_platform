if @customer_reg_info.present? && @customer_reg_info.verify_state == "verified"
  json.exist true
else
  json.exist false
end