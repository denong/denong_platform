class CreateLakalaTrades < ActiveRecord::Migration
  def change
    create_table :lakala_trades do |t|
      t.string :phone
      t.string :card
      t.float :price
      t.string :pos_ind
      t.string :shop_ind
      t.string :trade_ind
      t.string :trade_time
      t.references :pos_machine, index: true
      t.references :shop, index: true
      t.references :customer, index: true
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
