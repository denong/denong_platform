class AddMerchantRefToTlTrade < ActiveRecord::Migration
  def change
    add_reference :tl_trades, :merchant, index: true
  end
end
