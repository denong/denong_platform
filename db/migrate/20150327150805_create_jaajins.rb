class CreateJaajins < ActiveRecord::Migration
  def change
    create_table :jaajins do |t|
      t.float :got
      t.float :unverify
      t.references :customer, index: true

      t.timestamps
    end
  end
end
