json.array!(@voters) do |voter|
  json.customer_id voter.customer_reg_info.customer_id
  json.name voter.customer_reg_info.name
  json.nick_name voter.customer_reg_info.nick_name
  json.gender voter.customer_reg_info.gender
  json.image image_url(voter.customer_reg_info.image.photo.url(:product)) if voter.customer_reg_info.image
end
