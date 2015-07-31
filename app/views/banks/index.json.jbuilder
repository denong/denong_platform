json.extract! @banks, :total_pages, :current_page
json.banks @banks do |bank|
  json.name bank.name
  json.id   bank.id
  json.bind_bank_card bank.bind_bank_card?(current_customer) if current_customer
  json.logo image_url("bank/#{bank.name}.png")
  json.bank_card_amount   bank.bank_card_amount
end