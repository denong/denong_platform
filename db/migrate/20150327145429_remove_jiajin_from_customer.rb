class RemoveJiajinFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :jiajin, :float
  end
end
