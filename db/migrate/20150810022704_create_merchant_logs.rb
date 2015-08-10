class CreateMerchantLogs < ActiveRecord::Migration
  def change
    create_table :merchant_logs do |t|
      t.datetime :datetime
      t.string :data_type
      t.string :name
      t.float :d_jajin_count
      t.float :w_jajin_count
      t.float :m_jajin_count
      t.float :all_jajin
      t.integer :d_user_count
      t.integer :w_user_count
      t.integer :m_user_count
      t.integer :all_user

      t.timestamps
    end
  end
end
