class AddAccountStateToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :account_state, :integer, default: 0
  end
end
