class RemoveIdcardFromCustomerRegInfo < ActiveRecord::Migration
  def change
    remove_column :customer_reg_infos, :idcard, :string
  end
end
