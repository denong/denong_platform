class AddAccountStateToIdentityVerify < ActiveRecord::Migration
  def change
    add_column :identity_verifies, :account_state, :integer, default: 3
  end
end
