class AddRefToBankCardTypes < ActiveRecord::Migration
  def change
    add_reference :bank_card_types, :bank, index: true
  end
end
