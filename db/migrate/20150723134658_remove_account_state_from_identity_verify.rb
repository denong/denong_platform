class RemoveAccountStateFromIdentityVerify < ActiveRecord::Migration
  def change
    remove_column :identity_verifies, :account_state, :integer
  end
end
