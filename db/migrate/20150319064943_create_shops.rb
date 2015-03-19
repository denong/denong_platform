class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :addr
      t.string :contact_person
      t.string :contact_tel
      t.string :work_time
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
