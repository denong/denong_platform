class AddCustomerRefToMerchantCustomer < ActiveRecord::Migration
  def change
    add_reference :merchant_customers, :customer, index: true
  end
end
