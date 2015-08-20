class AddPointLogInfoToMerchantLog < ActiveRecord::Migration
  def change
    add_column :merchant_logs, :d_point_sum, :float
    add_column :merchant_logs, :m_point_sum, :float
    add_column :merchant_logs, :w_point_sum, :float
    add_column :merchant_logs, :d_pension_sum, :float
    add_column :merchant_logs, :m_pension_sum, :float
    add_column :merchant_logs, :w_pension_sum, :float
  end
end
