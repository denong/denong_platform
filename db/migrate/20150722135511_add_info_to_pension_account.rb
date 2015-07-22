class AddInfoToPensionAccount < ActiveRecord::Migration
  def change
    add_column :pension_accounts, :phone, :string
    add_column :pension_accounts, :name, :string
  end
end
