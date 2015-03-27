class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.float :pension
      t.float :jiajin
      t.references :user, index: true

      t.timestamps
    end
  end
end
