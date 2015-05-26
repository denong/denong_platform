class AddPostCodeToShop < ActiveRecord::Migration
  def change
    add_column :shops, :post_code, :string
  end
end
