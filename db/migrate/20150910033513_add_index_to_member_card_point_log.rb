class AddIndexToMemberCardPointLog < ActiveRecord::Migration
  def change
    add_index :member_card_point_logs, :unique_ind, :unique => true
  end
end
