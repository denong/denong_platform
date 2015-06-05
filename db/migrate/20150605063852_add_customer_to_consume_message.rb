class AddCustomerToConsumeMessage < ActiveRecord::Migration
  def change
    add_reference :consume_messages, :customer, index: true
  end
end
