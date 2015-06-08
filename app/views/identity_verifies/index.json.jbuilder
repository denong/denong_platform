if @identity_verify.present?
  json.extract! @identity_verify, :id_card, :name, :verify_state
  json.front_image image_url(@identity_verify.front_image.photo.url(:product)) if @identity_verify.front_image
  json.back_image image_url(@identity_verify.back_image.photo.url(:product)) if @identity_verify.back_image
else
  json.verify_state "unverified"
end