json.extract! @customer_reg_info, :customer_id, :name, :id_card, :verify_state, :nick_name, :gender
json.image image_url(@customer_reg_info.image.photo.url(:product)) if @customer_reg_info.image