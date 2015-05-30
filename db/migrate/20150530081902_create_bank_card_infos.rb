class CreateBankCardInfos < ActiveRecord::Migration
  def change
    create_table :bank_card_infos do |t|
      t.string :bin
      t.string :bank
      t.string :card_type

      t.timestamps
    end
    add_index :bank_card_infos, :bin
  end
end
