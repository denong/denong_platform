class RemoveAccountStateFromCustomerRegInfo < ActiveRecord::Migration
  def change
    remove_column :customer_reg_infos, :account_state, :integer
  end
end
