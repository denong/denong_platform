class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :userid
      t.integer :friendid
      t.references :customer, index: true

      t.timestamps
    end
  end
end
