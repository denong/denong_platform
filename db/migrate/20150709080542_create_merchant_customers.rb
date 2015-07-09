class CreateMerchantCustomers < ActiveRecord::Migration
  def change
    create_table(:merchant_customers) do |t|
      ## Database authenticatable
      t.string :u_id,              null: false, default: ""
      t.string :password, null: false, default: ""
      t.string :name
      t.string :phone
      t.float :jifen
      t.integer :is_changed

      t.references :merchant, index: true

      t.timestamps
    end

    add_index :merchant_customers, :u_id,                unique: true
  end
end
