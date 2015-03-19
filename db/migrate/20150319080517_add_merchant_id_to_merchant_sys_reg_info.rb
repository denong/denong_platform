class AddMerchantIdToMerchantSysRegInfo < ActiveRecord::Migration
  def change
    add_reference :merchant_sys_reg_infos, :merchant, index: true
  end
end
