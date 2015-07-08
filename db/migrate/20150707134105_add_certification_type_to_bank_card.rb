class AddCertificationTypeToBankCard < ActiveRecord::Migration
  def change
    add_column :bank_cards, :certification_type, :string
  end
end
