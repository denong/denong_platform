class AddBankCardTypeToBankCard < ActiveRecord::Migration
  def change
    add_column :bank_cards, :bank_card_type, :integer
  end
end
