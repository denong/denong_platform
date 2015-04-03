class AddRatioToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :ratio, :float
  end
end
