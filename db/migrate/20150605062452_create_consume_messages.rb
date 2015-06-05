class CreateConsumeMessages < ActiveRecord::Migration
  def change
    create_table :consume_messages do |t|
      t.string :title
      t.datetime :trade_time
      t.float :amount
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
