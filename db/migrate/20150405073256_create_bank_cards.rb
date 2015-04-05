class CreateBankCards < ActiveRecord::Migration
  def change
    create_table :bank_cards do |t|
      t.string :bankcard_no
      t.string :id_card
      t.string :name
      t.string :phone
      t.integer :card_type
      t.string :sn
      t.integer :bank
      t.integer :bind_state
      t.datetime :bind_time
      t.references :customer, index: true

      t.timestamps
    end
  end
end
