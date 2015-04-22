class CreateJajinIdentityCodes < ActiveRecord::Migration
  def change
    create_table :jajin_identity_codes do |t|
      t.string :identity_code
      t.datetime :expiration_time
      t.references :customer, index: true
      t.references :merchant, index: true

      t.timestamps
    end
  end
end
