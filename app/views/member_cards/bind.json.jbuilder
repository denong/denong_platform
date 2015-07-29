json.extract! @member_card, :point, :merchant_id, :customer_id, :id, :user_name
json.member_card_amount @member_card.merchant.member_card_amount