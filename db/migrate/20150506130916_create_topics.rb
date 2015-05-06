class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :Title
      t.string :Subtitle

      t.timestamps
    end
  end
end
