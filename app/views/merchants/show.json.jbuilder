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
json.giving_jajin   @merchant.get_giving_jajin
json.customer_jajin_total @merchant.customer_jajin_total(current_customer) if current_customer
json.image image_url(@merchant.sys_reg_info.image.photo.url(:product)) if @merchant.sys_reg_info.image
json.logo image_url(@merchant.sys_reg_info.logo.photo.url(:product)) if @merchant.sys_reg_info.logo
json.follow_count  @merchant.follow_count
json.like_count @merchant.like_count
json.followed current_customer.voted_for?(@merchant, vote_scope: "follow") if current_customer
json.liked current_customer.voted_for?(@merchant, vote_scope: "like") if current_customer
json.bind_member_card @merchant.bind_member_card?(current_customer) if current_customer
json.ratio @merchant.ratio
json.contact_tel @merchant.sys_reg_info.contact_tel