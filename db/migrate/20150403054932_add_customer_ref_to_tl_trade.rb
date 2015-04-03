class AddCustomerRefToTlTrade < ActiveRecord::Migration
  def change
    add_reference :tl_trades, :customer, index: true
  end
end
