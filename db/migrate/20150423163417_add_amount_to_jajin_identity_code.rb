class AddAmountToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_column :jajin_identity_codes, :amount, :float
  end
end
