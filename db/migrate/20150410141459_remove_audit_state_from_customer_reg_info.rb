class RemoveAuditStateFromCustomerRegInfo < ActiveRecord::Migration
  def change
    remove_column :customer_reg_infos, :audit_state, :integer
  end
end
