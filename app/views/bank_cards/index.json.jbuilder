json.array!(@bank_cards) do |bank_card|
  json.extract! bank_card, :id, :bankcard_no, :card_type, :name
end