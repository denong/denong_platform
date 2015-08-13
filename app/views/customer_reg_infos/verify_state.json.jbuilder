if @customer_reg_info.present?
  json.extract! @customer_reg_info, :customer_id, :name, :id_card, :verify_state, :account_state
else
  json.error "未找到该用户"
end