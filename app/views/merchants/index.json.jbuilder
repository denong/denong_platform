json.extract! @merchants, :total_pages, :current_page
json.merchants @merchants do |merchant|
  json.merchant_id    merchant.id
  json.sys_name       merchant.try(:sys_reg_info).try(:sys_name)
  json.service_tel    merchant.try(:sys_reg_info).try(:service_tel)
  json.lon            merchant.try(:sys_reg_info).try(:lon)
  json.lat            merchant.try(:sys_reg_info).try(:lat)
  json.welcome_string merchant.try(:sys_reg_info).try(:welcome_string)
  json.merchant_id    merchant.id
  json.follow_count  merchant.follow_count
  json.like_count merchant.like_count
  json.giving_jajin   merchant.get_giving_jajin
  json.customer_jajin_total merchant.customer_jajin_total(current_customer) if current_customer
  json.image image_url(merchant.try(:sys_reg_info).image.photo.url(:product)) if merchant.try(:sys_reg_info).image
  json.logo image_url(merchant.try(:sys_reg_info).logo.photo.url(:product)) if merchant.sys_reg_info.logo
  json.followed current_customer.voted_for?(merchant, vote_scope: "follow") if current_customer
  json.liked current_customer.voted_for?(merchant, vote_scope: "like") if current_customer
  json.bind_member_card merchant.bind_member_card?(current_customer) if current_customer
  json.member_card_amount merchant.member_card_amount
end