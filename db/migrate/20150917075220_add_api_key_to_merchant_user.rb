class AddApiKeyToMerchantUser < ActiveRecord::Migration
  def change
    add_column :merchant_users, :api_key, :string
  end
end
