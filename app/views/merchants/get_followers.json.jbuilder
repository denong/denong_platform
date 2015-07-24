json.total_pages @voters.total_pages
json.current_page @voters.current_page

json.followers(@voters) do |voter|
  next if voter.blank?
  next if voter.customer_reg_info.blank？
  
  json.customer_id voter.customer_reg_info.customer_id
  json.name voter.customer_reg_info.name
  json.nick_name voter.customer_reg_info.nick_name
  json.gender voter.customer_reg_info.gender
  json.image image_url(voter.customer_reg_info.image.photo.url(:product)) if voter.customer_reg_info.image
  json.pension voter.pension.total if voter.pension
  json.jajin voter.jajin.got if voter.jajin
  json.followed true
end
