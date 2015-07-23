class AddStateToPensionAccount < ActiveRecord::Migration
  def change
    add_column :pension_accounts, :state, :integer, default: 3
  end
end
