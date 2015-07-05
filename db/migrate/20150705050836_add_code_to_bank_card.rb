class AddCodeToBankCard < ActiveRecord::Migration
  def change
    add_column :bank_cards, :stat_code, :string
    add_column :bank_cards, :res_code, :string
  end
end
