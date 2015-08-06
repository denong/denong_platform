class AddBandCardInfoToBank < ActiveRecord::Migration
  def change
    add_column :banks, :debit_card_amount, :integer, default: 0
    add_column :banks, :credit_card, :integer, default: 0
  end
end
