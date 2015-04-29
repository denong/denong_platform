class AddStatusToBankCard < ActiveRecord::Migration
  def change
    add_column :bank_cards, :res_msg, :string
    add_column :bank_cards, :stat_desc, :string
  end
end
