class CreateTelecomUsers < ActiveRecord::Migration
  def change
    create_table :telecom_users do |t|
      t.string :phone, :unique => true
      t.string :name
      t.string :id_card
      t.float :point
      t.string :unique_ind

      t.timestamps
    end
  end
end
