json.extract! @member_card, :id, :point, :user_name
json.merchant_name @member_card.merchant_name
json.merchant_logo image_url(@member_card.merchant_logo)
json.merchant_giving_jajin @member_card.merchant_giving_jajin
json.customer_jajin_total @member_card.merchant.customer_jajin_total(current_customer) if current_customer
json.total_trans_jajin @member_card.total_trans_jajin if current_customer
json.unconvert_jajin @member_card.point.to_f * ( @member_card.try(:merchant).try(:convert_ratio) || 1)
json.merchant_id @member_card.merchant_id
json.member_card_amount @member_card.merchant.member_card_amount