class AddColumnToMerchantLog < ActiveRecord::Migration
  def change
    add_column :merchant_logs, :d_price, :integer, default: 0
    add_column :merchant_logs, :w_price, :integer, default: 0
    add_column :merchant_logs, :m_price, :integer, default: 0
    add_column :merchant_logs, :all_price, :integer, default: 0
  end
end
