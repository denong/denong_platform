json.total_pages @yl_trades.total_pages
json.current_page @yl_trades.current_page
 
json.yl_trades @yl_trades do |yl_trade|
  json.extract! yl_trade, :id, :trade_time, :trade_currency, :trade_state, :gain, :expend, :merchant_ind, :pos_ind, :merchant_name, :merchant_type, :merchant_city, :trade_type, :trade_way, :merchant_addr, :customer_id, :merchant_id, :card
end
