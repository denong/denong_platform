if @bank_card
  json.extract! @bank_card, :id, :bankcard_no, :name, :phone, :res_msg, :stat_desc, :customer_id, :updated_at, :card_type_name, :bank_name
else
  json.error "验证失败"
end
