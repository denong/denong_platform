class AddNickNameToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :nick_name, :string
  end
end
