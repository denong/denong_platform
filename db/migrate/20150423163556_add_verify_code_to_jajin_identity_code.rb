class AddVerifyCodeToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_column :jajin_identity_codes, :verify_code, :string
  end
end
