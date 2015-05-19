json.array!(@voters) do |voter|
  json.customer_id voter.customer_reg_info.customer_id
  json.name voter.customer_reg_info.name
  json.nick_name voter.customer_reg_info.nick_name
  json.gender voter.customer_reg_info.gender
end
