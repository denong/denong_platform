class RemoveAccountidFromPension < ActiveRecord::Migration
  def change
    remove_column :pensions, :account_id, :integer
  end
end
