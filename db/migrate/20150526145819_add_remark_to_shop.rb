class AddRemarkToShop < ActiveRecord::Migration
  def change
    add_column :shops, :remark, :string
  end
end
