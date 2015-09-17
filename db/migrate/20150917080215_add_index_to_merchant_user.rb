class AddIndexToMerchantUser < ActiveRecord::Migration
  def change
    add_index :merchant_users, :api_key, :unique => true
  end
end
