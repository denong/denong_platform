json.array! @jajin_logs do |jajin_log|
  json.id jajin_log.id
  json.amount jajin_log.amount
  json.log_time jajin_log.updated_at
  json.customer_id jajin_log.customer_id
  json.type jajin_log.jajinable_type
  json.detail jajin_log.jajinable.as_json
end