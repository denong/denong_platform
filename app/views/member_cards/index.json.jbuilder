json.total_pages @member_cards.total_pages
json.current_page @member_cards.current_page

json.member_cards @member_cards do |member_card|
  json.extract! member_card, :id, :point
end
