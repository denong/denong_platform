class AddIdCardToCustomerRegInfo < ActiveRecord::Migration
  def change
    add_column :customer_reg_infos, :id_card, :string
  end
end
