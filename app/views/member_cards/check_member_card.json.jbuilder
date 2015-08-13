if @member_card.present?
  json.exist true
else
  json.exist false
end