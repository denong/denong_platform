  json.extract! @member_card_point_log, :id, :point, :created_at, :jajin, :member_card_id
  json.pension @member_card_point_log.jajin.to_f/100