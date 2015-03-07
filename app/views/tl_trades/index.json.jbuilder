json.array!(@tl_trades) do |tl_trade|
  json.extract! tl_trade, :id, :phone, :card, :price, :trade_time, :pos_ind, :shop_ind, :trade_ind
  json.url tl_trade_url(tl_trade, format: :json)
end
