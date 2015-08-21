class CreateStatusCodes < ActiveRecord::Migration
  def change
    create_table :status_codes do |t|
      t.string :level
      t.string :code
      t.string :name
      t.string :interface

      t.timestamps
    end
  end
end
