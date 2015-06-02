json.extract! @member_card, :id, :point, :user_name
json.merchant_name @member_card.merchant_name
json.merchant_logo image_url(@member_card.merchant_logo)
json.merchant_giving_jajin @member_card.merchant_giving_jajin