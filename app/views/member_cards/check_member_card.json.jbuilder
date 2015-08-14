if @member_card.present?
  json.exist true
  json.extract! @member_card, :id
else
  json.exist false
end