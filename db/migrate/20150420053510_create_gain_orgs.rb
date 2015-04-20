class CreateGainOrgs < ActiveRecord::Migration
  def change
    create_table :gain_orgs do |t|
      t.string :title
      t.string :sub_title

      t.timestamps
    end
  end
end
