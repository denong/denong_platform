unless @bank_card.errors.present?
  json.extract! @bank_card, :id, :bankcard_no, :name, :id_card, :customer_id, :created_at, :updated_at, :bank_name, :bank_id, :bank_card_type
  json.bank_logo image_url("bank/#{@bank_card.bank_name}.png")
  json.bank_card_amount @bank_card.try(:bank).try(:bank_card_amount)
else
  json.error @bank_card.errors.first.last
end