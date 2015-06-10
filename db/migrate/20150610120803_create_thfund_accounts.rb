class CreateThfundAccounts < ActiveRecord::Migration
  def change
    create_table :thfund_accounts do |t|
      t.integer :sn
      t.integer :certification_type
      t.string :certification_no
      t.string :name
      t.datetime :transaction_time
      t.integer :account_id
      t.string :mobile
      t.references :customer, index: true
      t.integer :state

      t.timestamps
    end
    add_index :thfund_accounts, :sn
    add_index :thfund_accounts, :account_id
    add_index :thfund_accounts, :mobile
    add_index :thfund_accounts, :state
  end
end
