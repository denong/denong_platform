class CreatePointLogFailureInfos < ActiveRecord::Migration
  def change
    create_table :point_log_failure_infos do |t|
      t.string :id_card
      t.string :name
      t.string :phone
      t.integer :point
      t.string :unique_ind
      t.references :merchant, index: true
      t.integer :error_code

      t.timestamps
    end
  end
end
