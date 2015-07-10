class RemoveMemberCardFromMemberCardPointLog < ActiveRecord::Migration
  def change
    remove_column :member_card_point_logs, :member_card, :string
  end
end
