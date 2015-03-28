class RemovePensionFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :pension, :float
  end
end
