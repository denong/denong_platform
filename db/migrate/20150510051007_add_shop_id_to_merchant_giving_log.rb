class AddShopIdToMerchantGivingLog < ActiveRecord::Migration
  def change
    add_reference :merchant_giving_logs, :shop, index: true
  end
end
