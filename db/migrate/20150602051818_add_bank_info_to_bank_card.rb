class AddBankInfoToBankCard < ActiveRecord::Migration
  def change
    add_column :bank_cards, :bank_name, :string
    add_column :bank_cards, :card_type_name, :string
  end
end
