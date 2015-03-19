class CreateMerchantSysRegInfos < ActiveRecord::Migration
  def change
    create_table :merchant_sys_reg_infos do |t|
      t.string :sys_name
      t.string :contact_person
      t.string :contact_tel, array: true, default: []
      t.string :service_tel, array: true, default: []
      t.string :fax_tel, array: true, default: []
      t.string :email
      t.string :company_addr
      t.string :region
      t.string :industry
      t.string :postcode
      t.datetime :reg_time
      t.datetime :approve_time
      t.float :lon
      t.float :lat
      t.string :welcome_string
      t.text :comment_text
      t.references :merchant_user, index: true

      t.timestamps
    end
  end
end
