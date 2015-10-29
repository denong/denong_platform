class AddAmountToLakalaTrade < ActiveRecord::Migration
  def change
    add_column :lakala_trades, :amount, :float
  end
end
