class CreateCustomerRegInfos < ActiveRecord::Migration
  def change
    create_table :customer_reg_infos do |t|
      t.references :customer, index: true
      t.string :name
      t.string :idcard
      t.integer :audit_state

      t.timestamps
    end
  end
end
