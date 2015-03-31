class CreateJajinLogs < ActiveRecord::Migration
  def change
    create_table :jajin_logs do |t|
      t.float :amount
      t.references :jajinable, polymorphic: true, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
