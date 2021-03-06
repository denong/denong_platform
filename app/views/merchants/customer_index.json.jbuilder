json.extract! @merchants, :total_pages, :current_page
json.merchant_count @merchants.count
json.merchant_jajin current_customer.try(:jajin).try(:got).to_f / 100
json.merchants @merchants do |merchant|
  json.sys_name       merchant.sys_reg_info.sys_name
  json.service_tel    merchant.sys_reg_info.service_tel
  json.lon            merchant.sys_reg_info.lon
  json.lat            merchant.sys_reg_info.lat
  json.welcome_string merchant.sys_reg_info.welcome_string
  json.merchant_id    merchant.id
  json.votes_up       merchant.votes_up
  json.giving_jajin   merchant.get_giving_jajin
  json.image          image_url(merchant.sys_reg_info.image.photo.url(:product)) if merchant.sys_reg_info.image
  json.logo          image_url(merchant.sys_reg_info.logo.photo.url(:product)) if merchant.sys_reg_info.logo
  if merchant.merchant_messages.present?
    json.message        merchant.merchant_messages.first, :time, :title, :content, :summary, :url
    json.message_thumb image_url(merchant.merchant_messages.first.thumb.photo.url(:product)) if merchant.merchant_messages.first.thumb
  end
end