if @customer_reg_info.customer_id == current_customer.id
  json.extract! @customer_reg_info, :customer_id, :name, :id_card, :verify_state, :nick_name, :gender
else
  json.extract! @customer_reg_info, :customer_id, :name, :nick_name, :gender
end
json.image image_url(@customer_reg_info.image.photo.url(:small)) if @customer_reg_info.image

