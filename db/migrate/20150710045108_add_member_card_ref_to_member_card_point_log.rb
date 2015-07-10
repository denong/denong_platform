class AddMemberCardRefToMemberCardPointLog < ActiveRecord::Migration
  def change
    add_reference :member_card_point_logs, :member_card, index: true
  end
end
