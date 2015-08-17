class AddColumnToMerchantLog < ActiveRecord::Migration
  def change
    add_column :merchant_logs, :d_price, default: 0
    add_column :merchant_logs, :w_price, default: 0
    add_column :merchant_logs, :m_price, default: 0
    add_column :merchant_logs, :all_price, default: 0
  end
end
