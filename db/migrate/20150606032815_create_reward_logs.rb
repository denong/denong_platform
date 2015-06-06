class CreateRewardLogs < ActiveRecord::Migration
  def change
    create_table :reward_logs do |t|
      t.references :reward, index: true
      t.references :customer, index: true
      t.references :merchant, index: true
      t.string :amount
      t.string :float
      t.string :verify_code
      t.datetime :verify_time

      t.timestamps
    end
  end
end
