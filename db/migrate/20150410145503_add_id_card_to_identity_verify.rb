class AddIdCardToIdentityVerify < ActiveRecord::Migration
  def change
    add_column :identity_verifies, :id_card, :string
  end
end
