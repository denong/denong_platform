class AddTradeTimeToJajinIdentityCode < ActiveRecord::Migration
  def change
    add_column :jajin_identity_codes, :trade_time, :string
  end
end
