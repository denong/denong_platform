class AddColumnToMemberCard < ActiveRecord::Migration
  def change
    add_column :member_cards, :total_trans_jajin, :float, default: 0
    add_column :merchants, :convert_ratio, :float, default: 1
  end
end
