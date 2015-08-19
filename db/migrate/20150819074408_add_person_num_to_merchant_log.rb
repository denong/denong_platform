class AddPersonNumToMerchantLog < ActiveRecord::Migration
  def change
    add_column :merchant_logs, :d_point_user_count, :integer
    add_column :merchant_logs, :w_point_user_count, :integer
    add_column :merchant_logs, :m_point_user_count, :integer
  end
end
