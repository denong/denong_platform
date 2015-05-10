class AddConsumptionToMerchantGivingLog < ActiveRecord::Migration
  def change
    add_column :merchant_giving_logs, :consumption, :float
  end
end
