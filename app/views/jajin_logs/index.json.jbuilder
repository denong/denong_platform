json.total_pages @jajin_logs.total_pages
json.current_page @jajin_logs.current_page

json.jajin_logs @jajin_logs do |jajin_log|
  json.id jajin_log.id
  json.amount jajin_log.amount
  json.log_time jajin_log.updated_at
  json.customer_id jajin_log.customer_id
  json.company jajin_log.jajinable.company if jajin_log.jajinable.respond_to?(:company)
  json.type jajin_log.jajinable_type
  json.detail jajin_log.jajinable.as_json
  json.merchant_logo image_url(jajin_log.merchant_logo)
  json.merchant_name jajin_log.merchant_name
end