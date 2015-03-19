class CreatePosMachines < ActiveRecord::Migration
  def change
    create_table :pos_machines do |t|
      t.integer :acquiring_bank
      t.string :operator
      t.datetime :opertion_time
      t.references :shop, index: true

      t.timestamps
    end
  end
end
