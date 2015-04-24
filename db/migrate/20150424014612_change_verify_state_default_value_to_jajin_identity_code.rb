class ChangeVerifyStateDefaultValueToJajinIdentityCode < ActiveRecord::Migration
  def change
    change_column :jajin_identity_codes, :verify_state, :integer, default: 0
  end
end
