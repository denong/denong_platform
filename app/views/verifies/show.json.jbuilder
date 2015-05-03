if @jajin_verify_log.present? && (!@jajin_verify_log.errors.present?)
  json.extract! @jajin_verify_log, :amount, :verify_time, :customer_id, :merchant_id, :verify_code
else
  json.nil!
end