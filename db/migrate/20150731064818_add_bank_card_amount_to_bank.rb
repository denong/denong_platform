class AddBankCardAmountToBank < ActiveRecord::Migration
  def change
    add_column :banks, :bank_card_amount, :integer, default: 0
  end
end
