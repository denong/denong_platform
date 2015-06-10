class AddAccountStateToIdentityVerify < ActiveRecord::Migration
  def change
    add_column :identity_verifies, :account_state, :integer, default: 0
    add_index :identity_verifies, :account_state
  end
end
