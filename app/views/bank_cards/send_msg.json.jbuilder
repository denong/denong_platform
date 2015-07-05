if @bank_card
  json.extract! @bank_card, :id, :bankcard_no, :name, :phone, :res_msg, :stat_desc, :stat_code, :res_code, :customer_id, :updated_at
else
  json.error "验证失败"
end