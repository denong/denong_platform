class AddLatToShop < ActiveRecord::Migration
  def change
    add_column :shops, :lat, :float
  end
end
