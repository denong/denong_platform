class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :phone
      t.string :contact_person
      t.string :fax
      t.string :addr
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
