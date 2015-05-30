json.extract! @merchants, :total_pages, :current_page
json.merchants @merchants do |merchant|
  json.merchant_id    merchant.id
  json.sys_name       merchant.sys_reg_info.sys_name
  json.service_tel    merchant.sys_reg_info.service_tel
  json.lon            merchant.sys_reg_info.lon
  json.lat            merchant.sys_reg_info.lat
  json.welcome_string merchant.sys_reg_info.welcome_string
  json.merchant_id    merchant.id
  json.votes_up       merchant.votes_up
  json.giving_jajin   merchant.get_giving_jajin
  json.image image_url(merchant.sys_reg_info.image.photo.url(:product)) if merchant.sys_reg_info.image
  json.logo image_url(merchant.sys_reg_info.logo.photo.url(:product)) if merchant.sys_reg_info.logo
  json.followed current_customer.voted_for?(merchant) if current_customer
end