class RemoveIdNumFromIdentityVerify < ActiveRecord::Migration
  def change
    remove_column :identity_verifies, :id_num, :string
  end
end
