json.array!(@reward_logs) do |reward_log|
  json.extract! reward_log, :id, :reward_id, :customer_id, :merchant_id, :amount, :float, :verify_code, :verify_time
  json.url reward_log_url(reward_log, format: :json)
end
