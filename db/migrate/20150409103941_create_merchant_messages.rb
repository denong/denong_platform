class CreateMerchantMessages < ActiveRecord::Migration
  def change
    create_table :merchant_messages do |t|
      t.datetime :time
      t.string :title
      t.string :content
      t.string :summary
      t.string :url
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
