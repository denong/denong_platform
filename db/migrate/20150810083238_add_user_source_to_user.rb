class AddUserSourceToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_source, :integer, default: 0
    add_column :users, :source_id, :integer, default: 3
  end
end
