json.array!(@bank_cards) do |bank_card|
  json.extract! bank_card, :id, :bank_name, :card_type_name, :bankcard_no, :name, :phone, :res_msg, :stat_desc
end