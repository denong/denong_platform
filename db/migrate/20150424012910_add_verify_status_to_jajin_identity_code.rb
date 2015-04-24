class AddVerifyStatusToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_column :jajin_identity_codes, :verify_state, :integer
  end
end
