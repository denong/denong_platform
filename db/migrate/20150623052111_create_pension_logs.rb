class CreatePensionLogs < ActiveRecord::Migration
  def change
    create_table :pension_logs do |t|
      t.references :customer, index: true
      t.float :jajin_amount
      t.float :amount

      t.timestamps
    end
  end
end
