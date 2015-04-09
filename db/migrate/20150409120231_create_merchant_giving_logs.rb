class CreateMerchantGivingLogs < ActiveRecord::Migration
  def change
    create_table :merchant_giving_logs do |t|
      t.float :amount
      t.datetime :giving_time
      t.references :merchant, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
