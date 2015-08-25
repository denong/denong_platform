if @customer_reg_info.present? && @customer_reg_info.errors.present?
  json.exist false
  json.errors @customer_reg_info.errors.first.last
elsif @customer_reg_info.present? && @customer_reg_info.verify_state == "verified"
  json.exist true
else
  json.exist false
end