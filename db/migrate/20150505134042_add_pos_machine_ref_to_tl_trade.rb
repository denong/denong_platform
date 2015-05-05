class AddPosMachineRefToTlTrade < ActiveRecord::Migration
  def change
    add_reference :tl_trades, :pos_machine, index: true
  end
end
