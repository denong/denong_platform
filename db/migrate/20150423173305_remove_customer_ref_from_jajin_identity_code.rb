class RemoveCustomerRefFromJajinIdentityCode < ActiveRecord::Migration
  def change
    remove_reference :jajin_identity_codes, :customer, index: true
  end
end
