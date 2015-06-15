class AddShopToTlTrade < ActiveRecord::Migration
  def change
    add_reference :tl_trades, :shop, index: true
  end
end
