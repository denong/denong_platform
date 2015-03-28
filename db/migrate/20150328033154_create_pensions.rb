class CreatePensions < ActiveRecord::Migration
  def change
    create_table :pensions do |t|
      t.integer :account
      t.float :total
      t.references :customer, index: true

      t.timestamps
    end
  end
end
