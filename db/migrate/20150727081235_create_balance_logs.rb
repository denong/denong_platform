class CreateBalanceLogs < ActiveRecord::Migration
  def change
    create_table :balance_logs do |t|
      t.float :jajin
      t.float :balance
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
