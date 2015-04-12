class AddLonToShop < ActiveRecord::Migration
  def change
    add_column :shops, :lon, :float
  end
end
