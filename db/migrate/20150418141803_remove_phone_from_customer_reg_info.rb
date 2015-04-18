class RemovePhoneFromCustomerRegInfo < ActiveRecord::Migration
  def change
    remove_column :customer_reg_infos, :phone, :string
  end
end
