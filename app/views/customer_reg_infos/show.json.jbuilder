if @customer_reg_info.customer_id == current_customer.id
  json.extract! @customer_reg_info, :customer_id, :name, :id_card, :verify_state, :nick_name, :gender
  json.pension @customer_reg_info.customer.try(:pension).try(:total)
  json.account @customer_reg_info.customer.try(:pension).try(:account)
  json.jajin_got @customer_reg_info.customer.try(:jajin).got
  json.jajin_unverify @customer_reg_info.customer.try(:jajin).unverify

  json.bank_cards @customer_reg_info.customer.try(:bank_cards).map {|bank_card| bank_card.bankcard_no}
  json.following_ids @customer_reg_info.customer.get_voted(Merchant) do |merchant|
    json.merchant_id merchant.id
    json.sys_name merchant.sys_reg_info.sys_name
    json.contact_person merchant.sys_reg_info.contact_person
    json.service_tel merchant.sys_reg_info.service_tel
    json.fax_tel merchant.sys_reg_info.fax_tel
    json.email merchant.sys_reg_info.email
    json.company_addr merchant.sys_reg_info.company_addr
    json.region merchant.sys_reg_info.region
    json.postcode merchant.sys_reg_info.postcode
    json.lon merchant.sys_reg_info.lon
    json.lat merchant.sys_reg_info.lat
    json.welcome_string merchant.sys_reg_info.welcome_string
    json.comment_text merchant.sys_reg_info.comment_text
    json.votes_up  merchant.votes_up
    json.giving_jajin   merchant.get_giving_jajin
    json.merchant_image merchant.sys_reg_info.image if merchant.sys_reg_info.image
  end
  json.following_number @customer_reg_info.customer.votes.size
else
  json.extract! @customer_reg_info, :customer_id, :name, :nick_name, :gender
end
json.image image_url(@customer_reg_info.image.photo.url(:small)) if @customer_reg_info.image

