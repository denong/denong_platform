class AddVerifyStateToMerchantMessage < ActiveRecord::Migration
  def change
    add_column :merchant_messages, :verify_state, :integer
  end
end
