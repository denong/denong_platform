class AddCardToYlTrade < ActiveRecord::Migration
  def change
    add_column :yl_trades, :card, :string
  end
end
