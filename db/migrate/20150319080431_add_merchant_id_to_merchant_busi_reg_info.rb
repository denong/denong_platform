class AddMerchantIdToMerchantBusiRegInfo < ActiveRecord::Migration
  def change
    add_reference :merchant_busi_reg_infos, :merchant, index: true
  end
end
