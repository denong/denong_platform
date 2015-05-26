class AddWelcomeTextToShop < ActiveRecord::Migration
  def change
    add_column :shops, :welcome_text, :string
  end
end
