class AddUniqueIndToMemberCardPointLog < ActiveRecord::Migration
  def change
    add_column :member_card_point_logs, :unique_ind, :string
  end
end
