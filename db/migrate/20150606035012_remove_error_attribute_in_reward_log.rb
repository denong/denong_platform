class RemoveErrorAttributeInRewardLog < ActiveRecord::Migration
  def change
    remove_column :reward_logs, :float
    remove_column :reward_logs, :amount

    add_column :reward_logs, :amount, :float
  end
end
