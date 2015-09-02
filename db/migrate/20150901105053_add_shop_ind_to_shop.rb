class AddShopIndToShop < ActiveRecord::Migration
  def change
    add_column :shops, :shop_ind, :string
  end
end
