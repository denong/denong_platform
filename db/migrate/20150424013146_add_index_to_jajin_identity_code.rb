class AddIndexToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_index :jajin_identity_codes, :verify_code
  end
end
