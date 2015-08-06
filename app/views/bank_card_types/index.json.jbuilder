json.extract! @bank_card_types, :total_pages, :current_page
json.bank_card_types @bank_card_types do |bank_card_type|
  json.name bank_card_type.bank_name
  json.id   bank_card_type.try(:bank).id
  json.bind_bank_card bank_card_type.try(:bank).bind_bank_card?(current_customer, bank_card_type.bank_card_type) if current_customer
  json.logo image_url("bank/#{bank_card_type.try(:bank).name}.png")
  json.bank_card_amount   bank_card_type.try(:bank).bank_card_amount
  json.debit_card_amount   bank_card_type.try(:bank).debit_card_amount
  json.credit_card_amount   bank_card_type.try(:bank).credit_card_amount
  json.bank_card_type bank_card_type.bank_card_type
end