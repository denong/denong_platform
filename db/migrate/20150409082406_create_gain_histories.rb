class CreateGainHistories < ActiveRecord::Migration
  def change
    create_table :gain_histories do |t|
      t.float :gain
      t.datetime :gain_date
      t.references :customer, index: true

      t.timestamps
    end
  end
end
