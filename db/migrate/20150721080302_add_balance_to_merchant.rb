class AddBalanceToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :balance, :float, default: 0
  end
end
