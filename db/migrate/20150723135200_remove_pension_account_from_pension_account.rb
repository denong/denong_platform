class RemovePensionAccountFromPensionAccount < ActiveRecord::Migration
  def change
    remove_column :pension_accounts, :state, :integer
  end
end
