class CreateTlTrades < ActiveRecord::Migration
  def change
    create_table :tl_trades do |t|
      t.string :phone
      t.string :card
      t.float :price
      t.datetime :trade_time
      t.string :pos_ind
      t.string :shop_ind
      t.string :trade_ind

      t.timestamps
    end
    add_index :tl_trades, :phone
    add_index :tl_trades, :pos_ind
    add_index :tl_trades, :shop_ind
    add_index :tl_trades, :trade_ind
  end
end
