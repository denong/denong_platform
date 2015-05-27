class AddUserNameToMemberCard < ActiveRecord::Migration
  def change
    add_column :member_cards, :user_name, :string
  end
end
