class AddCustomerRefToGivenLog < ActiveRecord::Migration
  def change
    add_reference :given_logs, :customer, index: true
  end
end
