if @member_card_point_log.present? && @member_card_point_log.errors.present?
  json.error @member_card_point_log.errors.first.last
elsif @member_card_point_log.present?
  json.extract! @member_card_point_log, :point, :jajin, :member_card_id, :unique_ind
  json.pension @member_card_point_log.jajin.to_f/100
  json.merchant @member_card_point_log.try(:member_card).try(:merchant_id)
else
  json.error "参数错误"
end