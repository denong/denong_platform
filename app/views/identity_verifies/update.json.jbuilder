json.extract! @identity_verify, :id, :name, :id_card, :verify_state
json.front_image image_url(@identity_verify.front_image.photo.url(:product)) if @identity_verify.front_image
json.back_image image_url(@identity_verify.back_image.photo.url(:product)) if @identity_verify.back_image