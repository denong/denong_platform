class CreateExchangeLogs < ActiveRecord::Migration
  def change
    create_table :exchange_logs do |t|
      t.references :customer, index: true
      t.float :amount

      t.timestamps
    end
  end
end
