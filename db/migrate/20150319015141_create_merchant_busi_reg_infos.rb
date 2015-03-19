class CreateMerchantBusiRegInfos < ActiveRecord::Migration
  def change
    create_table :merchant_busi_reg_infos do |t|
      t.string :name
      t.string :addr
      t.string :legal
      t.string :id_card
      t.string :licence
      t.string :organize_code
      t.string :tax_code
      t.references :merchant_user, index: true

      t.timestamps
    end
  end
end
