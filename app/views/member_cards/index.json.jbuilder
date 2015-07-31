json.total_pages @member_cards.total_pages
json.current_page @member_cards.current_page

json.member_cards @member_cards do |member_card|
  json.extract! member_card, :id, :point, :user_name
  json.merchant_name member_card.merchant_name
  json.merchant_logo image_url(member_card.merchant_logo)
  json.merchant_giving_jajin member_card.merchant_giving_jajin
  json.total_trans_jajin member_card.total_trans_jajin
  json.unconvert_jajin member_card.point.to_f * ( member_card.try(:merchant).try(:convert_ratio) || 1)
  json.merchant_id member_card.merchant_id
  json.member_card_amount member_card.try(:merchant).try(:member_card_amount)
end
