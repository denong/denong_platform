json.merchant_id @merchant.id
json.sys_name @merchant.sys_reg_info.sys_name
json.contact_person @merchant.sys_reg_info.contact_person
json.service_tel @merchant.sys_reg_info.service_tel
json.fax_tel @merchant.sys_reg_info.fax_tel
json.email @merchant.sys_reg_info.email
json.company_addr @merchant.sys_reg_info.company_addr
json.region @merchant.sys_reg_info.region
json.postcode @merchant.sys_reg_info.postcode
json.lon @merchant.sys_reg_info.lon
json.lat @merchant.sys_reg_info.lat
json.welcome_string @merchant.sys_reg_info.welcome_string
json.comment_text @merchant.sys_reg_info.comment_text
json.votes_up  @merchant.votes_up
json.giving_jajin   @merchant.get_giving_jajin
json.followed current_customer.voted_for?(merchant) if current_customer
json.image image_url(@merchant.sys_reg_info.image.photo.url(:product)) if @merchant.sys_reg_info.image
json.logo image_url(@merchant.sys_reg_info.logo.photo.url(:product)) if @merchant.sys_reg_info.logo