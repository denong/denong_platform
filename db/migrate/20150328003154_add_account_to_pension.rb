class AddAccountToPension < ActiveRecord::Migration
  def change
    add_column :pensions, :account, :integer
  end
end
