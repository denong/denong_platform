class AddMerchantIdToJajinLog < ActiveRecord::Migration
  def change
    add_reference :jajin_logs, :merchant, index: true
  end
end
