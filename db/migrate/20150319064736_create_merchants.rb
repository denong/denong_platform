class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.references :merchant_user

      t.timestamps
    end
  end
end
