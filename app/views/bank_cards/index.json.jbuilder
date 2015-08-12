json.array!(@bank_cards) do |bank_card|
  json.extract! bank_card, :id, :bank_name, :card_type_name, :bankcard_no, :name, :phone, :res_msg, :stat_desc, :bank_id, :bank_card_type

  json.bank_logo image_url("bank/#{bank_card.bank_name}.png")
  json.bank_card_amount bank_card.try(:bank).try(:bank_card_amount)
  
end