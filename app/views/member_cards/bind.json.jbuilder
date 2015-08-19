if @member_card.errors.present?
  puts "#{json.error @member_card.errors}"
  json.error @member_card.errors.first.last
elsif @member_card.present?
  json.extract! @member_card, :point, :merchant_id, :customer_id, :id, :user_name
  json.member_card_amount (@member_card.try(:merchant).try(:member_card_amount)||0)
elsif @error_code == "7201001"
  json.errors "用户不存在"
end