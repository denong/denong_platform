class AddAccountStateToCustomerRefInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :account_state, :integer, default: 3
  end
end
