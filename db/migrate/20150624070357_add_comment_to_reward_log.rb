class AddCommentToRewardLog < ActiveRecord::Migration
  def change
    add_column :reward_logs, :comment, :string
  end
end
