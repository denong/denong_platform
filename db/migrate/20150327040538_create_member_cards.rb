class CreateMemberCards < ActiveRecord::Migration
  def change
    create_table :member_cards do |t|
      t.references :merchant, index: true
      t.float :point, default: 0
      t.references :customer, index: true

      t.timestamps
    end
  end
end
