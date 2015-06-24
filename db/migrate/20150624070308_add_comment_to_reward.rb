class AddCommentToReward < ActiveRecord::Migration
  def change
    add_column :rewards, :comment, :string
    add_index :rewards, :comment
  end
end
