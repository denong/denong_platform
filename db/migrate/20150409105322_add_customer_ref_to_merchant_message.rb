class AddCustomerRefToMerchantMessage < ActiveRecord::Migration
  def change
    add_reference :merchant_messages, :customer, index: true
  end
end
