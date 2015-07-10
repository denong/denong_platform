class CreateMemberCardPointLogs < ActiveRecord::Migration
  def change
    create_table :member_card_point_logs do |t|
      t.string :member_card
      t.float :point
      t.float :jajin
      t.references :customer, index: true

      t.timestamps
    end
  end
end
