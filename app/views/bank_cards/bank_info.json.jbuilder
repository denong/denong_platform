json.bank @bank_card_info.try(:bank)
json.card_type @bank_card_info.try(:card_type)
json.bankcard_no @bankcard_no
json.bank_logo image_url("bank/#{bank_card_info.try(:bank)}")