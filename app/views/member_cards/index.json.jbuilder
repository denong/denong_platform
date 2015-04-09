json.array!(@member_cards) do |member_card|
  json.extract! member_card, :id, :point
end
