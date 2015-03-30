class ChangeAccountTypeInPension < ActiveRecord::Migration
  def change
    remove_column :pensions, :account, :integer
    add_column :pensions, :account, :string
  end
end
