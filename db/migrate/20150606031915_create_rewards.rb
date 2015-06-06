class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.float :amount
      t.string :verify_code, unique: true
      t.integer :max
      t.references :merchant, index: true

      t.timestamps
    end
    add_index :rewards, :verify_code
  end
end
