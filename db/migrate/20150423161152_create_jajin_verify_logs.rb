class CreateJajinVerifyLogs < ActiveRecord::Migration
  def change
    create_table :jajin_verify_logs do |t|
      t.float :amount
      t.string :verify_code
      t.datetime :verify_time
      t.references :customer, index: true
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
