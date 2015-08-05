json.extract! @member_card, :point, :merchant_id, :customer_id, :id, :user_name
json.member_card_amount (@member_card.try(:merchant).try(:member_card_amount)||0)