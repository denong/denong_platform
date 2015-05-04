class AddTradeTimeToTlTrade < ActiveRecord::Migration
  def change
    add_column :tl_trades, :trade_time, :string
  end
end
