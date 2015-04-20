class CreateGainAccounts < ActiveRecord::Migration
  def change
    create_table :gain_accounts do |t|
      t.references :customer, index: true
      t.references :gain_org, index: true
      t.float :total

      t.timestamps
    end
  end
end
