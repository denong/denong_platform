class CreateGivenLogs < ActiveRecord::Migration
  def change
    create_table :given_logs do |t|
      t.integer :giver_id
      t.integer :given_id
      t.float :ammout

      t.timestamps
    end
    add_index :given_logs, :giver_id
    add_index :given_logs, :given_id
  end
end
