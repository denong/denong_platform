class RemoveMerchantUserIdFromMerchantBusiRegInfo < ActiveRecord::Migration
  def change
    remove_reference :merchant_busi_reg_infos, :merchant_user, index: true
  end
end
