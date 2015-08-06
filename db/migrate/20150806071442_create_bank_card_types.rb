class CreateBankCardTypes < ActiveRecord::Migration
  def change
    create_table :bank_card_types do |t|
      t.string :bank_name
      t.integer :bank_card_type

      t.timestamps
    end
  end
end
