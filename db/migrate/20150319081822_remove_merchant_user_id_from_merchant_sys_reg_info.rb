class RemoveMerchantUserIdFromMerchantSysRegInfo < ActiveRecord::Migration
  def change
    remove_reference :merchant_sys_reg_infos, :merchant_user, index: true
  end
end
