class AddConsumptionToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :consumption_total, :float
    add_column :merchants, :jajin_total, :float
    add_column :merchants, :consume_count, :integer
  end
end
