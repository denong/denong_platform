class AddCompanyToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_column :jajin_identity_codes, :company, :string
    add_index :jajin_identity_codes, :company
  end
end
