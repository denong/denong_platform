class AddPriceToConsumeMessage < ActiveRecord::Migration
  def change
    add_column :consume_messages, :price, :float
  end
end
