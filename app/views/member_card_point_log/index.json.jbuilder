if @member_card_point_logs.present?
  json.total_pages @member_card_point_logs.total_pages
  json.current_page @member_card_point_logs.current_page
  json.log_num @size
  
  json.member_card_point_logs @member_card_point_logs do |member_card_point_log|
    json.extract! member_card_point_log, :id, :point, :created_at, :jajin, :member_card_id
    json.pension member_card_point_log.jajin.to_f/100
    json.merchant member_card_point_log.try(:member_card).try(:merchant_id)
  end
else
  json.total_pages 0
  json.current_page 1
  json.log_num 0
end