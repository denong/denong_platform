class RemoveBankFromBankCard < ActiveRecord::Migration
  def change
    remove_column :bank_cards, :bank, :integer
  end
end
