class AddPhoneToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :phone, :string
  end
end
