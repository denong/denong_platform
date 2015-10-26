class AddUniqueIndIndexToMemberCardPointLog < ActiveRecord::Migration
  def change
    add_index "telecom_users", "unique_ind", name: "index_telecom_users_on_unique_ind", using: :btree
    add_index "telecom_users", "id_card", name: "index_telecom_users_on_id_card", using: :btree
  end
end
