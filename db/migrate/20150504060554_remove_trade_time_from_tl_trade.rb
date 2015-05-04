class RemoveTradeTimeFromTlTrade < ActiveRecord::Migration
  def change
    remove_column :tl_trades, :trade_time, :datetime
  end
end
