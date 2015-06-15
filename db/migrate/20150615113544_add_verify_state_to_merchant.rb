class AddVerifyStateToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :verify_state, :integer
    add_index :merchants, :verify_state
  end
end
