class CreateIdentityVerifies < ActiveRecord::Migration
  def change
    create_table :identity_verifies do |t|
      t.string :name
      t.string :id_num
      t.integer :verify_state
      t.references :customer, index: true

      t.timestamps
    end
  end
end
