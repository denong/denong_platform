class AddAgentToMerchant < ActiveRecord::Migration
  def change
    add_reference :merchants, :agent, index: true
  end
end
