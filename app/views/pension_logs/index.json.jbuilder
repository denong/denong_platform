json.total_pages @pension_logs.total_pages
json.current_page @pension_logs.current_page

json.pension_logs(@pension_logs) do |pension_log|
  json.extract! pension_log, :customer_id, :jajin_amount, :amount, :updated_at
end
