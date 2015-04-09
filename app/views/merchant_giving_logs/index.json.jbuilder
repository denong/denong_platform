json.total_pages @merchant_giving_logs.total_pages
json.current_page @merchant_giving_logs.current_page

json.merchant_giving_logs @merchant_giving_logs do |merchant_giving_log|
  json.extract! merchant_giving_log, :id, :amount, :giving_time, :merchant_id, :customer_id, :created_at, :updated_at
  json.type "merchant_giving"
end
