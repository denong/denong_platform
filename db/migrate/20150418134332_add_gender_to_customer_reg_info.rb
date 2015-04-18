class AddGenderToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :gender, :integer
  end
end
