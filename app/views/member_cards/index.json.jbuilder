json.total_pages @member_cards.total_pages
json.current_page @member_cards.current_page

json.member_cards @member_cards do |member_card|
  json.extract! member_card, :id, :point, :user_name
  json.merchant_name member_card.merchant_name
  json.merchant_logo image_url(member_card.merchant_logo)
  json.merchant_giving_jajin member_card.merchant_giving_jajin
  json.customer_jajin_total member_card.merchant.customer_jajin_total(current_customer) if current_customer
  json.total_trans_jajin member_card.total_trans_jajin
  json.unconvert_jajin member_card.point*member_card.merchant.convert_ratio
  json.merchant_id member_card.merchant_id
end
