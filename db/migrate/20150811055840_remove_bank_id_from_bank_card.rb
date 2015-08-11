class RemoveBankIdFromBankCard < ActiveRecord::Migration
  def change
    remove_column :bank_cards, :bank_id, :integer
  end
end
