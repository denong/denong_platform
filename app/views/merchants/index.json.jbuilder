json.extract! @merchants, :total_pages, :current_page
json.merchants @merchants do |merchant|
  json.merchant_id    merchant.id
  json.sys_name       merchant.sys_reg_info.sys_name
  json.service_tel    merchant.sys_reg_info.service_tel
  json.lon            merchant.sys_reg_info.lon
  json.lat            merchant.sys_reg_info.lat
  json.welcome_string merchant.sys_reg_info.welcome_string
  json.merchant_id    merchant.id
  json.follow_count  merchant.follow_count
  json.like_count merchant.like_count
  json.giving_jajin   merchant.get_giving_jajin
  json.customer_jajin_total merchant.customer_jajin_total(current_customer) if current_customer
  json.image image_url(merchant.sys_reg_info.image.photo.url(:product)) if merchant.sys_reg_info.image
  json.logo image_url(merchant.sys_reg_info.logo.photo.url(:product)) if merchant.sys_reg_info.logo
  json.followed current_customer.voted_for?(merchant, vote_scope: "follow") if current_customer
  json.liked current_customer.voted_for?(merchant, vote_scope: "like") if current_customer
  json.bind_member_card merchant.bind_member_card?(current_customer) if current_customer
  json.member_card_amount merchant.member_card_amount
end