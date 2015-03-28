class CreateJajins < ActiveRecord::Migration
  def change
    create_table :jajins do |t|
      t.float :got
      t.float :unverify
      t.references :customer, index: true

      t.timestamps
    end
  end
end
