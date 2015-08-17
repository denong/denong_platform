class CreateBankCardVerifyInfos < ActiveRecord::Migration
  def change
    create_table :bank_card_verify_infos do |t|
      t.string :name
      t.string :id_card
      t.string :bank_card
      t.integer :result

      t.timestamps
    end
  end
end
