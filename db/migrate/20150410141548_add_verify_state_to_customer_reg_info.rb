class AddVerifyStateToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :verify_state, :integer
  end
end
