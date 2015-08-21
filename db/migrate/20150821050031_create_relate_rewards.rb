class CreateRelateRewards < ActiveRecord::Migration
  def change
    create_table :relate_rewards do |t|
      t.string :phone
      t.string :verify_code
      t.timestamps
    end
    add_index :relate_rewards, :phone
  end
end
