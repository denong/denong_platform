if @identity_verify.present? && @identity_verify.errors.present?
  json.error @member_card_point_log.errors.full_messages.last
elsif @identity_verify.present?
  json.extract! @identity_verify, :name, :id_card, :verify_state
  json.front_image image_url(@identity_verify.front_image.photo.url(:product)) if @identity_verify.front_image
  json.back_image image_url(@identity_verify.back_image.photo.url(:product)) if @identity_verify.back_image
elsif @error_code == "7201001"
  json.errors "用户不存在"
end