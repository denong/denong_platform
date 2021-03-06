if @bank_card
  json.extract! @bank_card, :id, :bankcard_no, :name, :phone, :res_msg, :stat_desc, :res_code, :stat_code, :customer_id, :updated_at, :card_type_name, :bank_name, :bank_id, :bank_card_type
  json.bank_card_amount @bank_card.try(:bank).try(:bank_card_amount)
  json.bank_logo image_url("bank/#{@bank_card.bank_name}.png")
else
  json.error "验证失败"
end
