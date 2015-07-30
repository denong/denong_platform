class CreatePersonalInfos < ActiveRecord::Migration
  def change
    create_table :personal_infos do |t|
      t.string :name
      t.string :id_card

      t.timestamps
    end
  end
end
