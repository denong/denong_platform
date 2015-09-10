class RemoveIndexFromMemberCardPointLog < ActiveRecord::Migration
  def change
    remove_index :member_card_point_logs, :unique_ind
  end
end
