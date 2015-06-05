json.extract! @consume_message, :id, :title, :trade_time, :amount, :merchant_id, :customer_id

json.merchant_name @consume_message.try(:merchant).try(:sys_name)
json.merchant_logo @consume_message.try(:merchant).try(:sys_reg_info).try(:logo) ? image_url(@consume_message.merchant.sys_reg_info.logo.photo.url(:product)) : ""

