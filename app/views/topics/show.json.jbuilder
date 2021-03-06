json.extract! @topic, :title, :subtitle
json.merchant_num @topic.merchants.size
json.pic image_url(@topic.pic.photo.url(:product)) if @topic.pic
json.merchants @topic.merchants do |merchant|
  json.sys_name       merchant.sys_reg_info.sys_name
  json.service_tel    merchant.sys_reg_info.service_tel
  json.lon            merchant.sys_reg_info.lon
  json.lat            merchant.sys_reg_info.lat
  json.welcome_string merchant.sys_reg_info.welcome_string
  json.merchant_id    merchant.id
  json.votes_up       merchant.votes_up
  json.merchant_logo image_url(merchant.sys_reg_info.logo.photo.url(:product)) if merchant.sys_reg_info.logo
  json.image image_url(merchant.sys_reg_info.image.photo.url(:product)) if merchant.sys_reg_info.image
end