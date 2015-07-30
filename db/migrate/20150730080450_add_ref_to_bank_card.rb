class AddRefToBankCard < ActiveRecord::Migration
  def change
    add_reference :bank_cards, :bank, index: true
  end
end
