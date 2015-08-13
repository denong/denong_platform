class AddUniqueIdToMemberCardPointLog < ActiveRecord::Migration
  def change
    add_column :member_card_point_logs, :unique_id, :string
  end
end
