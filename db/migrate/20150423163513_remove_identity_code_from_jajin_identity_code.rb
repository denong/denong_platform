class RemoveIdentityCodeFromJajinIdentityCode < ActiveRecord::Migration
  def change
    remove_column :jajin_identity_codes, :identity_code, :string
  end
end
