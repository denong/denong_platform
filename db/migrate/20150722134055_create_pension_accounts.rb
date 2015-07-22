class CreatePensionAccounts < ActiveRecord::Migration
  def change
    create_table :pension_accounts do |t|
      t.string :id_card
      t.integer :state, default: 0
      t.references :customer, index: true
      t.string :account

      t.timestamps
    end
  end
end
