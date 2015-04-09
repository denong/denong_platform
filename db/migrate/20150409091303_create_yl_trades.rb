class CreateYlTrades < ActiveRecord::Migration
  def change
    create_table :yl_trades do |t|
      t.datetime :trade_time
      t.date :log_time
      t.string :trade_currency
      t.string :trade_state
      t.float :gain
      t.float :expend
      t.string :merchant_ind
      t.string :pos_ind
      t.string :merchant_name
      t.string :merchant_type
      t.string :merchant_city
      t.string :trade_type
      t.string :trade_way
      t.string :merchant_addr
      t.references :customer, index: true
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
