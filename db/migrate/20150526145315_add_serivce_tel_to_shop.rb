class AddSerivceTelToShop < ActiveRecord::Migration
  def change
    add_column :shops, :service_tel, :string
  end
end
